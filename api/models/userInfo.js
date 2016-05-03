module.exports = {
  tableName: 'userInfo',
  adapter: 'mysql',
  autoCreatedAt: false,
  autoUpdatedAt: false,
  attributes: {
    'username': {
      type: 'string',
      size: 50,
      unique: true,
      primaryKey: true
    },
    'password': {
      type: 'string',
      size: 30
    }
  }
};