require 'rails_helper'

RSpec.describe 'Post', :js, type: :feature do
  def sign_in(user)
    within('form') do
      fill_in 'Email', with: user.email
      fill_in 'Пароль', with: user.password
      click_button 'Войти'
    end
  end

  let(:user) { create(:user) }

  before(:each) do
    visit root_path
    sign_in(user)
  end

  feature 'Post' do
    scenario 'success create post' do
      visit(new_post_path)
      page.attach_file(Rails.root.join('spec/fixtures/pixel.jpeg')) do
        page.find('input', text: 'Выберите файл').click
      end
      find_field(name: 'post[description]').set('lorem ipsum')
      find_field(name: 'commit').click
      expect(page).to have_content 'lorem ipsum'
    end

    scenario 'failed create post' do
      visit(new_post_path)
      page.attach_file(Rails.root.join('spec/fixtures/pixel.jpeg')) do
        page.find('input', text: 'Выберите файл').click
      end
      find_field(name: 'post[description]').set('')
      find_field(name: 'commit').click
      expect(page).to have_content 'Ваш новый пост не создан! Пожалуйста, проверьте форму.'
    end
  end
end