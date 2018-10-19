# frozen_string_literal: true

Rails.application.routes.draw do
  get 'clock', to: 'clock#index'
  get 'welcome/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'welcome#index'
end
