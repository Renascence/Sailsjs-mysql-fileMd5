module.exports = {
  tableName: 'md5values',
  adapter: 'mysql',
  autoCreatedAt: false,
  autoUpdatedAt: false,
  attributes: {
    id: {
      type: 'int',
      unique: true,
      primaryKey: true,
    },
    md5: {
      type: 'string'
    },
    hot: {
      type: 'int'
    },
    name: {
      type: 'string'
    }
  }
};