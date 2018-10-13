module DatabaseConnection

  # TODO - get database details from yml
  # Its not a singleton yet
  # Have to create a singleton if not already
  def get_db_connection
    @db ||= SQLite3::Database.open("spectacles-#{Rails.env}.db")
  end
end