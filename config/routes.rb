# frozen_string_literal: true

Rails.application.routes.draw do
  get 'timings/:id', to: 'timings#show'
  get 'page/index'
  root 'page#index'
end
