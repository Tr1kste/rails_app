require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create :user }
  let(:params) { { post: attributes_for(:post) } }

  before { sign_in user }

  context 'before actions' do
    it { should use_before_action(:authenticate_user!) }

    it { should use_before_action(:set_post) }
  end

  describe '#index' do
    subject { process :index, method: :post, params: params }

    let!(:post) { create :post, user: user }

    it 'assigns @posts' do
      subject
      expect(assigns(:posts)).to eq([post])
    end

    it { should render_template('index') }

    context 'when user is not sign in' do
      before { sign_out user }

      it { should redirect_to(new_user_session_path) }
    end
  end

  describe '#show' do
    subject { process :show, params: params }

    let(:params) { { user_id: user.id, id: post } }
    let!(:post) { create :post, user: user }

    it 'assigns @post' do
      subject
      expect(assigns(:post)).to eq(post)
    end

    it { should render_template('show') }
  end

  describe '#new' do
    subject { process :new }

    it 'assigns @post' do
      subject
      expect(assigns(:post)).to be_a_new Post
    end

    it { should render_template('new') }
  end

  describe '#create' do
    subject { process :create, method: :post, params: params }

    context 'success' do
      let(:params) { { post: attributes_for(:post, user: create(:user)) } }

      it 'create a post' do
        expect { subject }.to change(Post, :count).by(1)
      end

      it 'flash message success create' do
        subject
        expect(flash[:success]).to be_present
      end

      it 'assigns post to current user' do
        subject
        expect(assigns(:post).user).to eq user
      end

      it 'permit' do
        should permit(:description, :image, :user_id).for(:create, params: params).on(:post)
      end
    end

    context 'invalid params' do
      let(:params) { { post: { user_id: nil, post: { description: nil } } } }

      it { should render_template('new') }

      it 'post not create' do
        expect { subject }.not_to change(user.posts, :count)
      end

      it 'flash message alert create' do
        subject
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe '#edit' do
    subject { process :edit, method: :get, params: params }

    let(:params) { { id: post, user_id: user } }
    let!(:post) { create :post, user: user }

    it { should render_template('edit') }

    it 'assigns server policy' do
      subject
      expect(assigns(:post)).to eq post
    end

    context 'user tries to edit someones post' do
      let!(:post) { create :post }

      it { should redirect_to(root_path) }

      it 'does not edit post' do
        expect { subject }.not_to change { post.reload }
      end

      it 'flash message alert edit' do
        subject
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe '#update' do
    subject { process :update, method: :put, params: params }

    let!(:post) { create :post, user: user }
    let(:params) { { id: post, user_id: user, post: { description: 'description' } } }

    it { should redirect_to(post_path(post.id)) }

    it 'updates post' do
      expect { subject }.to change { post.reload.description }.to('description')
    end

    it 'flash message success update' do
      subject
      expect(flash[:success]).to be_present
    end
  end

  describe '#destroy' do
    subject { process :destroy, method: :delete, params: params }

    let(:params) { { id: post.id } }

    context 'success delete' do
      let!(:post) { create :post, user: user }

      it 'delete the post' do
        expect { subject }.to change(user.posts, :count).by(-1)
      end

      it 'flash message success delete' do
        subject
        expect(flash[:success]).to be_present
      end

      it { should redirect_to(root_path) }
    end

    context 'user tries to remove someones post' do
      let!(:post) { create :post }

      it { should redirect_to(root_path) }

      it 'does not delete post' do
        expect { subject }.not_to change(user.posts, :count)
      end

      it 'flash message alert delete' do
        subject
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe '.post_params' do
    it do
      should permit(:description, :image, :user_id)
        .for(:create, params: params)
        .on(:post)
    end
  end
end