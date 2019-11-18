## README

# *CLONE APP OF MERCARI
This is a clone app of MERCARI.MERCARI is one of the biggest e-commerce apps in Japan.<br>Users can sell and buy any commodities they want.


![view](mercari.gif)



# メルカリ DB設計

## usersテーブル
|Column|Type|Options|
|------|----|-------|
|nickname|string|null: false| <!--名前-->
|email|string|null: false| <!--メールアドレス-->
|password|string|null: false| <!--パスワード-->
|last_name|string|null: false| <!--姓-->
|first_name|string|null: false| <!--名-->
|last_name_kana|string|null: false| <!--姓（カナ）-->
|first_name_kana|string|null: false| <!--名（カナ）-->
|birthday_year|integer|null: false| <!--生年月日（年）-->
|birthday_month|integer|null: false| <!--生年月日（月）-->
|birthday_day|integer|null: false| <!--生年月日（日）-->
|phone_number|integer|null: false| <!--電話番号-->
|card_number|integer|| <!--クレジットカード番号-->
|card_limit_month|integer|| <!--クレジットカード有効期限-->
|card_limit_year|integer|| <!--クレジットカード有効期限-->
|security_code|integer|| <!--セキュリティコード-->
|sales_money|integer|null: false| <!--売上金-->
|point|integer|null: false| <!--ポイント-->
### Association
- has_many :products
- has_many :comments
- has_many :messages
- has_many :evaluations
- has_many :todos
- has_one :address

<!--自分がフォローしているユーザーを取ってくる正方向の中間テーブル-->
- has_many :relationships

<!--擬似的にfollowingsと命名、user.followingsで自分がフォローしているユーザーを全て取ってくる-->
- has_many :followings, through: :relationships, source: :follower

<!--擬似的にreverse_of_relationshipsと命名、自分をフォローしているユーザーを取ってくる逆方向の中間テーブル-->
- has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'

<!--擬似的にfollowersと命名、user.followersで自分をフォローしているユーザーを全て取ってくる-->
- has_many :followers, through: :reverse_of_relationships, source: :user

<!--子要素が削除されたらこの要素も削除-->
- has_many :likes, dependent: :destroy

<!--擬似的にlike_productsと命名、user.like_productsでそのユーザーがいいねした商品全てを全て取ってくる-->
- has_many :like_products, through: :likes, source: :product


## productsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false, index: true| <!--商品名-->
|discription|text|| <!--商品説明-->
|condition|string|null: false, index: true| <!--商品の状態-->
|delivery_charge|string|null: false, index: true| <!--配送料の負担-->
|origin_area|string|null: false| <!--発送元の地域-->
|days_left_send|integer|null: false| <!--発送までの日数-->
|price|integer|null: false, index: true| <!--値段-->
|status|string|null: false, index: true| <!--ステータス(出品中か取引中か売却済み)-->
|user_id|references|null: false, foreign_key: true| <!--user_id-->
|buyer_id|references|foreign_key: { to_table: :users }| <!--購入者-->
|likes_count|integer|| <!--いいね数のカウンタ-->
### Association
- belongs_to :user
- has_one :detail
- has_many :images
- has_many :comments
- has_many :messages

<!--子要素が削除されたらこの要素も削除-->
- has_many :likes, dependent: :destroy

<!--擬似的にliking_usersと命名、products.liking_usersでその商品をいいねしたユーザー全てを全て取ってくる-->
- has_many :liking_users, through: :likes, source: :user


## commentsテーブル
|Column|Type|Options|
|------|----|-------|
|body|text|null: false| <!--コメント-->
|user_id|references|null: false, foreign_key: true| <!--user_id-->
|product_id|references|null: false, foreign_key: true| <!--product_id-->
### Association
- belongs_to :user
- belongs_to :product

## likesテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|references|null: false, foreign_key: true, index: true| <!--user_id-->
|product_id|references|null: false, foreign_key: true, index: true| <!--product_id-->
### Association
- belongs_to :user
- belongs_to :product, counter_cache: :likes_count <!--いいね数のカウンタを用意-->
### Option
[:user_id, :product_id], unique: true

## detailsテーブル
|Column|Type|Options|
|------|----|-------|
|large_category|string|null: false, index: true| <!--大項目カテゴリー-->
|medium_category|string|null: false, index: true| <!--中項目カテゴリー-->
|small_category|string|null: false, index: true| <!--小項目カテゴリー-->
|size|string|null: false, index: true| <!--サイズ-->
|brand|string|null: false, index: true| <!--ブランド-->
|product_id|references|null: false, foreign_key: true| <!--product_id-->
### Association
- belongs_to :product

## imagesテーブル
|Column|Type|Options|
|------|----|-------|
|img|string|null: false| <!--画像-->
|product_id|references|null: false, foreign_key: true| <!--product_id-->
### Association
- belongs_to :product

## messagesテーブル
|Column|Type|Options|
|------|----|-------|
|body|text|null: false| <!--コメント-->
|user_id|references|null: false, foreign_key: true| <!--user_id-->
|product_id|references|null: false, foreign_key: true| <!--product_id-->
### Association
- belongs_to :user
- belongs_to :product

## evaluationsテーブル
|Column|Type|Options|
|------|----|-------|
|rank|integer|null: false, foreign_key: true| <!--評価-->
|body|text|| <!--コメント-->
|user_id|references|null: false, foreign_key: true| <!--user_id-->
### Association
- belongs_to :user

## todosテーブル
|Column|Type|Options|
|------|----|-------|
|action|text|null: false| <!--やること-->
|user_id|references|null: false, foreign_key: true| <!--user_id-->
### Association
- belongs_to :user

## relationshipsテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|references|null: false, foreign_key: true, index: true,| <!--フォローする人-->
|follower_id|references|null: false, foreign_key: { to_table: :users }, index: true| <!--フォローされる人-->
### Association
- belongs_to :user
- belongs_to :follower, class_name: 'User' <!--擬似的にfollowと命名-->
### Option
[:user_id, :follower_id], unique: true

## addressesテーブル
|Column|Type|Options|
|------|----|-------|
|post_code|string|null: false| <!--郵便番号-->
|prefecture|string|null: false| <!--都道府県-->
|town|string|null: false| <!--市区町村-->
|street|string|null: false| <!--番地-->
|building_name|string|| <!--建物名-->
|user_id|references|null: false, foreign_key: true| <!--user_id-->
### Association
- belongs_to :user
