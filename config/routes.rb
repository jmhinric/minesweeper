Minesweeper::Application.routes.draw do

  root "minesweepers#index"
  get "/play", to: "minesweepers#edit"
  post "/play", to: "minesweepers#update"

end
