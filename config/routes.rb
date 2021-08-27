# frozen_string_literal: true

Rails.application.routes.draw do
  resources :points, only: [:index]
end
