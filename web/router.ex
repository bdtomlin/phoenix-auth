defmodule Support.Router do
  use Support.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Support.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug :require_current_user
  end

  scope "/", Support do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete

    resources "/issues", IssueController
    resources "/users", UserController, except: [:new, :edit]
  end

  scope "/admin", Support do
    pipe_through [:browser, :admin]
    resources "/users", UserController, except: [:new, :edit]
  end

  defp require_current_user(conn, _) do
    import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "unauthorized")
      |> redirect(to: "/")
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Support do
  #   pipe_through :api
  # end
end
