defmodule PlateSlateWeb.Schema.Mutation.UpdateMenuTest do
  use PlateSlateWeb.ConnCase, async: true

  alias PlateSlate.{Repo, Menu}
  import Ecto.Query

  setup do
    PlateSlate.Seeds.run()

    menu_item =
      from(t in Menu.Item, where: t.name == "Water")
      |> Repo.one!

    {:ok, menu_item: menu_item }
  end

  @query """
  mutation ($menuItem: MenuItemInput!) {
    updateMenuItem(input: $menuItem) {
      errors { key message }
      menuItem {
        name
        description
        price
      }
    }
  }
  """
  @tag :wip
  test "updateMenuItem field updates an item", %{menu_item: %{id: id, category_id: category_id}} do
    menu_item = %{
      "id" => id |> to_string,  
      "category_id" => category_id |> to_string,
      "name" => "Updated name",
      "description" => "Updated desc",
      "price" =>  "1.1"
    }
    conn = build_conn()
    conn = post conn, "/api",
      query: @query,
      variables: %{"menuItem" => menu_item}

    assert json_response(conn, 200) == %{
      "data" => %{
        "updateMenuItem" => %{
          "errors" => nil,
          "menuItem" => %{
            "name" => menu_item["name"],
            "description" => menu_item["description"],
            "price" => menu_item["price"]
          }
        }
      }
    }
  end
end
