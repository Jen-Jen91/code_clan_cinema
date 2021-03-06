require_relative("../db/sql_runner.rb")

class Ticket

  attr_reader(:id)
  attr_accessor(:customer_id, :film_id)

  def initialize(options)
    @id = options["id"].to_i() if options["id"]
    @customer_id = options["customer_id"].to_i()
    @film_id = options["film_id"].to_i()
  end

  def save()
    sql = "
      INSERT INTO tickets(customer_id, film_id)
      VALUES ($1, $2)
      RETURNING id;
    "
    values = [@customer_id, @film_id]
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"].to_i()
  end

  def self.delete_all()
    sql = "DELETE FROM tickets;"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1"
    SqlRunner.run(sql, [@id])
  end

  def self.all()
    sql = "SELECT * FROM tickets;"
    results = SqlRunner.run(sql)
    return results.map {|ticket| Ticket.new(ticket)}
  end

  def self.find(id)
    sql = "SELECT * FROM tickets WHERE id = $1;"
    result = SqlRunner.run(sql, [id])
    return Ticket.new(result[0])
  end

end
