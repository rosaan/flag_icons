defmodule Mix.Tasks.FlagIcons.Gen do
  use Mix.Task

  @shortdoc "Convert source SVG files into Phoenix LiveView components"
  def run(_) do
    loop_directory()
    Mix.Task.run("format")
  end

  defp loop_directory() do
    src_path = "./priv/flag-icons/flags/"
    dest_path = "./lib/flag_icon.ex"
    module_name = "FlagIcons"

    File.rm(dest_path)

    content =
      ["1x1", "4x3"]
      |> Enum.flat_map(&build_components_for_variant(src_path, &1))
      |> build_module(module_name)

    File.write!(dest_path, content)
  end

  defp build_components_for_variant(src_path, variant) do
    variant_path = Path.join(src_path, variant)

    variant_path
    |> File.ls!()
    |> Enum.filter(&(Path.extname(&1) == ".svg"))
    |> Enum.sort()
    |> Enum.map(&build_component(variant_path, variant, &1))
  end

  defp build_component(src_path, variant, filename) do
    svg_filepath = Path.join(src_path, filename)
    docs = filename

    svg_content =
      File.read!(svg_filepath)
      |> String.trim()
      |> String.replace(~r/<svg\s*/, "<svg {@attrs} ")

    filename |> function_name() |> build_function(variant, docs, svg_content)
  end

  defp function_name(current_filename) do
    current_filename
    |> Path.basename(".svg")
    |> String.split("-")
    |> Enum.join("_")
  end

  defp build_module(functions, module_name) do
    """
    defmodule #{module_name} do
      use Phoenix.Component

      def render(%{flag: flag, variant: "4x3"} = assigns) do
        function_name = "\#{flag}_4x3"
        function_atom = String.to_existing_atom(function_name)

        apply(__MODULE__, function_atom, [assigns])
      end

      def render(%{flag: flag} = assigns) do
        function_name = "\#{flag}_1x1"
        function_atom = String.to_existing_atom(function_name)

        apply(__MODULE__, function_atom, [assigns])
      end

      #{Enum.join(functions, "\n")}
    end
    """
  end

  defp build_function(function_name, variant, docs, svg) do
    """
    @doc "#{docs}"
    def #{function_name}_#{variant}(assigns) do
      attrs = assigns_to_attributes(assigns)
      assigns = assign(assigns, :attrs, attrs)

      ~H\"\"\"
      #{svg}
      \"\"\"
    end
    """
  end
end
