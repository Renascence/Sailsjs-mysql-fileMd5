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
    },
    toJSON: function() {
      var obj = this.toObject();
      delete obj.id;
      delete obj.hot;
      delete obj.md5;
      delete obj.name;
      // delete obj.attivo;
      // delete obj.data_inserimento;
      // delete obj.data_modifica;
      // delete obj.idadm_amministratore_inserimento;
      // delete obj.idadm_amministratore_modifica;
      // delete obj.ip_addr;
      // delete obj.pie_pagina;
      // delete obj.parole_chiave_ricerca;
      // delete obj.in_newsletter;
      // delete obj.in_evidenza;
      // delete obj.articolo_riservato;
      // return obj;
    }
  }
};