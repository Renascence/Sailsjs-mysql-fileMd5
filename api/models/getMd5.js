module.exports = {
  tableName: 'md5values',
  adapter: 'mysql',
  autoCreatedAt: false,
  autoUpdatedAt: false,
  attributes: {
    id: {
      type: 'string',
      unique: true,
      primaryKey: true,
    },
    md5: {
      type: 'string'
    },
    hot: {
      type: 'string'
    },
    name: {
      type: 'string'
    }
  }
};