def set_current_pack(email, password, password_confirmation)
  visit root_path
  click_link "Редактировать аккаунт"
  fill_in :profile_email, with: email
  fill_in :profile_password, with: password
  fill_in :profile_password_confirmation, with: password_confirmation
  select "pack1", from: "profile_current_pack_id"
  click_button "Обновить аккаунт"
end