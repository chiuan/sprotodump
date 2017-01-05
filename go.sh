echo 生成给go服务器 + c#相关的协议代码

#需要自己修改，自己电脑的文件
DUMP_DIR=/Users/chiuan/git/sprotodump
SPROTO_FILE=/Users/chiuan/git/dm_server/src/server/msg/proto.sproto
GO_ID_FILE=/Users/chiuan/git/dm_server/src/server/msg/msg.go
GO_PROTO_FILE=/Users/chiuan/git/dm_server/src/server/msg/proto.go
CS_ID_FILE=/Users/chiuan/git/tinysugar/sugar.unity/Assets/Scripts/Protocol/SprotoID.cs
CS_PROTO_FILE=/Users/chiuan/git/tinysugar/sugar.unity/Assets/Scripts/Protocol/Sproto.cs

cd $DUMP_DIR
lua sprotodump.lua -go $SPROTO_FILE -o $GO_PROTO_FILE -p msg
lua sprotodump.lua -cs $SPROTO_FILE -o $CS_PROTO_FILE
lua sprotodump.lua -id $SPROTO_FILE -goid $GO_ID_FILE -csid $CS_ID_FILE