
defmodule PlateSlateWeb.Schema.Middleware.PrintDuration do
  @moduledoc """
  Example of usage:
    field :menu_items, list_of(:menu_item) do
      arg :filter, :menu_item_filter
      
      middleware Middleware.PrintDuration
      resolve &Resolvers.Menu.menu_items/3
      middleware Middleware.PrintDuration
    end


  Output

  {
    menuItems(filter: {name: "reu"}) {
      name
    }
  }

  =>
  "Middleware.PrintDuration setup..."
  "PrintDuration:0.004msec"
  "Middleware.PrintDuration done!"

  TODO: Ignore text below. It was  stupid to add middleware to ALL fields in schema.
  But it's possible...

  "Middleware.PrintDuration executing..."
    "PrintDuration:0.031msec"
    "Middleware.PrintDuration done!"
    "setting up custom middleware  for field:menu_item"
    "setting up custom middleware  for field:menu_item"
    "setting up custom middleware  for field:menu_item"
    "setting up custom middleware  for field:menu_item"
    "setting up custom middleware  for field:menu_item"
    "setting up custom middleware  for field:menu_item"
    "Middleware.PrintDuration executing..."
    ["menuItems", 0, "name"]
    "Middleware.PrintDuration duplicate."
    "Middleware.PrintDuration executing..."
    ["menuItems", 0, "name"]
    "Middleware.PrintDuration duplicate.

    Why it's executed twice  for ["menuItems", 0, "name"] is a mystery to me right now...
  """
  @behaviour Absinthe.Middleware

  def call(res, rest) do

    context = res.context

    case get_in(context, [:duration_start_at]) do
        nil ->
            IO.inspect("Middleware.PrintDuration setup...")
            Map.put(res, :context, put_in(context, [:duration_start_at], DateTime.utc_now()))
        :done ->
            IO.inspect("Middleware.PrintDuration duplicate.")
            res
        duration_start_at ->
            IO.inspect(
                "PrintDuration:" <> inspect(DateTime.diff(DateTime.utc_now(), duration_start_at, :millisecond) / 1000) <> "msec"
            )
            IO.inspect("Middleware.PrintDuration done!")
            Map.put(res, :context, put_in(context, [:duration_start_at], :done))
    end

    
  end
end
