echo 生成给go服务器 + c#相关的协议代码

#需要自己修改，自己电脑的文件
DUMP_DIR=/Users/chiuan/git/sprotodump
SPROTO_FILE=/Users/chiuan/goproject/cluster_test/src/net/msg/proto.sproto
SPROTO_FILE_INDEX=/Users/chiuan/goproject/cluster_test/src/net/msg/proto.sproto.index

GO_ID_FILE=/Users/chiuan/goproject/cluster_test/src/net/msg/msg.go
GO_PROTO_FILE=/Users/chiuan/goproject/cluster_test/src/net/msg/proto.go

CS_PROTO_FILE=/Users/chiuan/goproject/cluster_test/src/net/msg/proto.cs
CS_ID_FILE=/Users/chiuan/goproject/cluster_test/src/net/msg/id.cs


cd $DUMP_DIR

#先生成协议的每条消息固定index序号文件
lua sprotodump.lua -index $SPROTO_FILE -o $SPROTO_FILE_INDEX

#go build
lua sprotodump.lua -go $SPROTO_FILE -o $GO_PROTO_FILE -p msg -i $SPROTO_FILE_INDEX
lua sprotodump.lua -id $SPROTO_FILE -goid $GO_ID_FILE -i $SPROTO_FILE_INDEX

#cs build
lua sprotodump.lua -cs $SPROTO_FILE -o $CS_PROTO_FILE
lua sprotodump.lua -id $SPROTO_FILE -csid $CS_ID_FILE -i $SPROTO_FILE_INDEX


echo
echo 生成完毕!