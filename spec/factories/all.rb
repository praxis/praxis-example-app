FactoryGirl.define do
  to_create { |i| i.save }

  factory :blog, class: Blog do
    traits_for! V1::MediaTypes::Blog

    name
    description
    url
    timestamps

    owner

    trait :with_posts do
      transient { post_count 5 }
      after :create do |blog, evaluator|
        create_list :post, evaluator.post_count, blog_id: blog.id
      end
    end
  end


  factory :post, class: Post do
    traits_for! V1::MediaTypes::Post

    title
    content
    url
    timestamps

    author
  end


  factory :user, class: User, aliases: [:author, :owner] do
    traits_for! V1::MediaTypes::User

    first
    last

    trait :with_posts do
      transient { post_count 5 }
      after :create do |user, evaluator|
        create_list :post, evaluator.post_count, author: user
      end
    end

  end

end
