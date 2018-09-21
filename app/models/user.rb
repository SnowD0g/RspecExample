class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :roles
  has_many :projects, through: :roles
  has_many :tasks

  def visible_projects
    return  Project.all if admin?
    (projects.to_a + Project.all_public.to_a).uniq.sort_by(&:id)
  end

  def can_view?(project)
    visible_projects.include?(project)
  end
end
