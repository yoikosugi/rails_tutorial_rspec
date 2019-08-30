require 'rails_helper'

RSpec.describe "ApplicationHelper", type: :system do
  describe "full title helper" do
    
    context "メソッドが引数を取る場合" do
      it "正しい値を返す" do
        expect(full_title("Help")).to eq "Help | Ruby on Rails Tutorial Sample App"
      end
    end

    context "メソッドが引数を取らない場合" do
      it "正しい値を返す" do
        expect(full_title("")).to eq "Ruby on Rails Tutorial Sample App"
      end
    end
  end
end
