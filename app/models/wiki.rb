class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :collaborators

  validates :body, presence: true
  validates :title,
    presence: true,
    uniqueness: { case_sensitve: false, scope: [:year]},
    length: { minimum: 3, maximum: 254}

  enum category: [:adventure, :dual_sport, :sport, :naked,
    :touring, :cruiser, :custom, :dirt, :roadster]

  enum final_drive: [:belt, :chain, :shaft]

  filterrific(
    default_filter_params: { sorted_by: 'title_asc'},
    available_filters: [
      :sorted_by,
      :search_query
    ]
  )

  scope :search_query, lambda { |query|
    return nil  if query.blank?

    terms = query.downcase.split(/\s+/)

    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    num_or_conds = 2
    where(
      terms.map { |term|
        "(LOWER(students.first_name) LIKE ? OR LOWER(students.last_name) LIKE ?)"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^title_/
      order("wikis.title #{ direction }")
    when /^cylinders_/
      order("wikis.cylinders #{ direction }")
    when /^hp_/
      order("wikis.hp #{ direction }")
    when /^torque_/
      order("wikis.torque #{ direction }")
    when /^displacement_/
      order("wikis.displacement #{ direction }")
    when /^year_/
      order("wikis.year #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def self.options_for_sorted_by
    [
      ['Title (a-z)', 'title_asc'],
      ['HP (most)', 'hp_desc'],
      ['HP (least)', 'hp_asc'],
      ['Torque (most)', 'torque_desc'],
      ['Torque (least)', 'torque_asc'],
      ['Year (oldest)', 'year_desc'],
      ['Year (newest)', 'year_asc'],
      ['Displacement (most)', 'displacement_desc'],
      ['Displacement (least)', 'displacement_asc'],
      ['Cylinders (most)', 'cylinders_desc'],
      ['Cylinders (least)', 'cylinders_asc'],
    ]
  end
end
