# Phoenix Flag Icons

A collection of Phoenix Components for all SVG [Flag Icons](https://flagicons.lipis.dev/). The icons are ISO 3166-1-alpha-2 flags available in two sizes: 1x1 and 4x3.

## Installation

To install the `flag_icons` library, add it to your `deps` in `mix.exs`:

```elixir
def deps do
  [
    {:flag_icons, "~> 0.1.0"}
  ]
end
```

## Usage

### Basic usage

Render a flag icon with the `1x1` variant:

```html
<FlagIcons.us_1x1 class="size-8" />
```

Render a flag icon with the `4x3` variant:

```html
<FlagIcons.us_4x3 class="h-8" />
```

### Dynamic Rendering:

Use the `render` function to dynamically select a flag based on a variable:

```html
<FlagIcons.render flag="us" variant="4x3" class="h-8" />
```

### Passing Additional Attributes

Any attributes passed will be forwarded to the SVG element:

```html
<FlagIcons.us_4x3 id="us-flag" class="inline-block h-8 w-12" />
```

## Creating Your Own Component

For further customization, consider wrapping `FlagIcons` within your own components:

```elixir
# core_components.ex

attr :flag, :string, required: true
attr :variant, :string, required: true, default: "1x1"
attr :class, :string, required: false, default: "icon"
attr :rest, :global

def flag_icon(assigns) do
  ~H"""
  <FlagIcons.render flag={@flag} variant={@variant} class={@class} {@rest} />
  """
end
```

This approach allows you to define and use custom attributes for your flag icon components.

### Usage in .html.heex Files

Use your custom component in your HTML (`html.heex`) files:

```html
<.flag_icon flag="us" variant="4x3" class="size-8" />
```

## License

Source code is licensed under the [MIT License](LICENSE.md).
