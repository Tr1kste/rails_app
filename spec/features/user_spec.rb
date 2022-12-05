# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User', :js, type: :feature do
  def sign_in(user)
    within('form') do
      fill_in 'Email', with: user.email
      fill_in 'Пароль', with: user.password
      click_button 'Войти'
    end
  end

  feature 'Sign up' do
    let!(:user) { build(:user) }

    scenario 'success sign up' do
      visit new_user_registration_path
      within('form') do
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: user.password
        fill_in 'Подтверждение пароля', with: user.password_confirmation
        click_button 'Зарегистрироваться'
      end
      expect(page).to have_content 'Welcome! You have signed up successfully.'
      expect(page).to have_current_path(root_path)
    end

    scenario 'failed sign up' do
      visit new_user_registration_path
      within('form') do
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: user.password
        fill_in 'Подтверждение пароля', with: 'fail'
        click_button 'Зарегистрироваться'
      end
      expect(page).to have_content '1 error'
    end
  end

  feature 'Sign in' do
    let!(:user) { create(:user) }

    scenario 'success sign in' do
      visit root_path
      sign_in(user)
      expect(page).to have_content 'Signed in successfully.'
      expect(page).to have_current_path(root_path)
    end

    scenario 'failed sign in' do
      visit root_path
      within('form') do
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: nil
        click_button 'Войти'
      end
      expect(page).to have_content 'Invalid Email or password.'
    end
  end
end