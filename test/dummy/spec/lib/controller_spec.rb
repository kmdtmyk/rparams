# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TestsController, type: :controller do
  include ActiveSupport::Testing::TimeHelpers

  describe 'apply_each_rparam' do

    describe 'inclusion' do

      example do
        get :index, params: { order: 'asc' }
        @controller.apply_each_rparam :order, inclusion: %w(asc desc)
        expect(@controller.params[:order]).to eq 'asc'

        get :index, params: { order: 'foo' }
        @controller.apply_each_rparam :order, inclusion: %w(asc desc)
        expect(@controller.params[:order]).to eq nil
      end

      describe 'with default value' do

        example do
          get :index, params: { order: 'asc' }
          @controller.apply_each_rparam :order, inclusion: %w(asc desc), default: 'asc'
          expect(@controller.params[:order]).to eq 'asc'

          get :index, params: { order: 'foo' }
          @controller.apply_each_rparam :order, inclusion: %w(asc desc), default: 'asc'
          expect(@controller.params[:order]).to eq 'asc'
        end

      end

    end

    describe 'type: Date' do

      example do
        get :index, params: { date: '2018-12-15' }
        @controller.apply_each_rparam :date, type: Date
        expect(@controller.params[:date]).to eq Date.new(2018, 12, 15)

        get :index, params: { date: 'invalid' }
        @controller.apply_each_rparam :date, type: Date
        expect(@controller.params[:date]).to eq nil
      end

    end

    describe 'save' do

      example 'true' do
        get :index, params: { order: 'asc' }
        @controller.apply_each_rparam :order, save: true
        expect(@controller.params[:order]).to eq 'asc'
        expect(ControllerParameter.count).to eq 0

        get :index
        @controller.apply_each_rparam :order, save: true
        expect(@controller.params[:order]).to eq 'asc'
        expect(ControllerParameter.count).to eq 0
      end

      example 'false' do
        get :index, params: { order: 'asc' }
        @controller.apply_each_rparam :order, save: false
        expect(@controller.params[:order]).to eq 'asc'
        expect(ControllerParameter.count).to eq 0

        get :index
        @controller.apply_each_rparam :order, save: false
        expect(@controller.params[:order]).to eq nil
        expect(ControllerParameter.count).to eq 0
      end

    end

    describe 'login user' do

      let!(:user){ User.create }
      before{ allow(@controller).to receive(:current_user).and_return(user) }

      describe 'save' do

        example 'true' do
          get :index, params: { order: 'asc' }
          @controller.apply_each_rparam :order, save: true
          expect(@controller.params[:order]).to eq 'asc'
          expect(ControllerParameter.count).to eq 1

          get :index
          @controller.apply_each_rparam :order, save: true
          expect(@controller.params[:order]).to eq 'asc'
          expect(ControllerParameter.count).to eq 1
        end

        example 'false' do
          get :index, params: { order: 'asc' }
          @controller.apply_each_rparam :order, save: false
          expect(@controller.params[:order]).to eq 'asc'
          expect(ControllerParameter.count).to eq 0

          get :index
          @controller.apply_each_rparam :order, save: false
          expect(@controller.params[:order]).to eq nil
          expect(ControllerParameter.count).to eq 0
        end

      end

      describe 'save relative date' do

        example do
          travel_to Date.new(2018, 10, 15)
          get :index, params: { date: '2018-10-20' }
          @controller.apply_each_rparam :date, type: Date, save: { relative_by: Date.today }
          expect(@controller.params[:date]).to eq Date.new(2018, 10, 20)
          expect(ControllerParameter.count).to eq 1
          expect(ControllerParameter.first.value).to eq '5'

          get :index
          @controller.apply_each_rparam :date, type: Date, save: { relative_by: Date.today }
          expect(@controller.params[:date]).to eq Date.new(2018, 10, 20)

          travel 5.days
          get :index
          @controller.apply_each_rparam :date, type: Date, save: { relative_by: Date.today }
          expect(@controller.params[:date]).to eq Date.new(2018, 10, 25)
        end

        example 'blank' do
          get :index, params: { date: '' }
          @controller.apply_each_rparam :date, type: Date, save: { relative_by: Date.today }
          expect(@controller.params[:date]).to eq nil
          expect(ControllerParameter.count).to eq 1
          expect(ControllerParameter.first.value).to eq ''
        end

        example 'without params' do
          get :index
          @controller.apply_each_rparam :date, type: Date, save: { relative_by: Date.today }
          expect(@controller.params[:date]).to eq nil
          expect(ControllerParameter.count).to eq 0
        end

      end

    end

  end

end
