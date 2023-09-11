const mysql = require('mysql')

var connection = mysql.createConnection({
  host     : process.env.MYSQL_HOST || 'assessment-1.ckedyzdhrei1.ap-south-1.rds.amazonaws.com',
  user     : process.env.MYSQL_USER || 'admin',
  password : process.env.MYSQL_PASSWORD || 'admin123',
  database : process.env.MYSQL_DATABASE || 'app3000'
})
 
connection.connect()

function createPost(description, image_url, callback) {

  const query = `
  INSERT INTO posts (description, image_url)
  VALUES (?, ?)
  `

  const params = [description, image_url]

  connection.query(query, params, (error, result) => {
    if (error) {
      callback(error)
      return
    }
    callback(null, result.insertId)
  })
}
exports.createPost = createPost

function getPosts(callback) {
  const query = `
  SELECT * FROM posts
  `

  connection.query(query, (error, results) => {
    if (error) {
      callback(error)
      return
    }
    callback(null, results)
  })
}
exports.getPosts = getPosts
 
