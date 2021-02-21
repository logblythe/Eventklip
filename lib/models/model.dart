import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';


part 'model.g.dart';


const MediaTypeVideo = 1;
const MediaTypeImage = 2;

const mediaTable = SqfEntityTable(
    tableName: 'media',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,
    fields: [
      SqfEntityField('path', DbType.text),
      SqfEntityField('userEmail', DbType.text),
      SqfEntityField('userPhone', DbType.text),
      SqfEntityField('adminId', DbType.text),
      SqfEntityField('eventId', DbType.text),
      SqfEntityField('filename', DbType.text),
      SqfEntityField('createdAt', DbType.datetimeUtc),
      SqfEntityField('mediaType', DbType.integer, defaultValue: 0),
      SqfEntityField('isUploaded', DbType.bool, defaultValue: false),
    ]);

@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
    modelName: 'Eventklip', // optional
    databaseName: 'eventklip.db',
    databaseTables: [mediaTable],);
