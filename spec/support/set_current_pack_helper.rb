def set_current_pack(email, password, password_confirmation, current_pack_id)
  visit root_path
  click_link "Редактировать профиль"
  fill_in :profile_email, with: email
  fill_in :profile_password, with: password
  fill_in :profile_password_confirmation, with: password_confirmation
  select "pack1", from: "profile_current_pack_id"
  click_button "Обновить"
end