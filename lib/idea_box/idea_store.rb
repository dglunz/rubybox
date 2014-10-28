require 'yaml/store'
class IdeaStore
  def self.database
    return @database if @database
    @database ||= YAML::Store.new 'db/ideabox'
    @database.transaction { @database['ideas'] ||= [] }
    @database
  end

  def self.find(id)
    Idea.new find_raw(id).merge('id' => id)
  end

  def self.find_raw(id)
    database.transaction { database['ideas'].at(id) }
  end

  def self.delete(position)
    database.transaction { database['ideas'].delete_at(position) }
  end

  def self.update(id, data)
    database.transaction { database['ideas'][id] = data }
  end

  def self.all
    raw_ideas.each_with_index.map {|data, i| Idea.new(data.merge('id' => i))}
  end

  def self.raw_ideas
    database.transaction { |db| db['ideas'] || [] }
  end

  def self.create(attributes)
    database.transaction { database['ideas'] << attributes }
  end
end
