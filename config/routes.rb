Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  put 'random' => 'ai#random';
  put 'easy' => 'ai#easy'
end
