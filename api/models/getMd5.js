module.exports = {
  tableName: 'md5Info',
  adapter: 'mysql',
  autoCreatedAt: false,
  autoUpdatedAt: false,
  attributes: {
    'id': {
      type: 'integer',
      size: 10,
      unique: true,
      primaryKey: true
    },
    'name': {
      type: 'string',
      size: 50
    },
    'md5': {
      type: 'string',
      size: 50
      
    },
    'type': {
      type: 'string',
      size: 50
      
    },
    'hot': {
      size: 10,      
      type: 'integer'
    }
  }
};