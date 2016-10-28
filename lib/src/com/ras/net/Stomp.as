package com.ras.net {
    import com.worlize.websocket.WebSocket;

    import flash.net.Socket;

    import org.codehaus.stomp.Stomp;
    import org.codehaus.stomp.headers.AbortHeaders;
    import org.codehaus.stomp.headers.AckHeaders;
    import org.codehaus.stomp.headers.BeginHeaders;
    import org.codehaus.stomp.headers.CommitHeaders;
    import org.codehaus.stomp.headers.ConnectHeaders;
    import org.codehaus.stomp.headers.SendHeaders;
    import org.codehaus.stomp.headers.SubscribeHeaders;
    import org.codehaus.stomp.headers.UnSubscribeHeaders;

    public class Stomp {
        private var _stomp:org.codehaus.stomp.Stomp;
        private var _socket:Socket;

        public function Stomp(websocket:WebSocket) {
            _socket = new WebSocketToSocketAdapter(websocket);
            _stomp = new org.codehaus.stomp.Stomp();
        }

        public function connect(connectHeaders:ConnectHeaders = null):void {
            _stomp.connect(null, null, connectHeaders, _socket);
        }

        public function close():void {
            _stomp.close();
        }

        public function subscribe(destination:String, headers:SubscribeHeaders = null):void {
            _stomp.subscribe(destination, headers);
        }

        public function send(destination:String, message:Object, headers:SendHeaders = null):void {
            _stomp.send(destination, message, headers);
        }

        public function sendTextMessage(destination:String, message:String, headers:SendHeaders = null):void {
            _stomp.sendTextMessage(destination, message, headers);
        }

        public function begin(transaction:String, headers:BeginHeaders = null):void {
            _stomp.begin(transaction, headers);
        }

        public function commit(transaction:String, headers:CommitHeaders = null):void {
            _stomp.commit(transaction, headers);
        }

        public function ack(messageID:String, headers:AckHeaders = null):void {
            _stomp.ack(messageID, headers);
        }

        public function abort(transaction:String, headers:AbortHeaders = null):void {
            _stomp.abort(transaction, headers);
        }

        public function unsubscribe(destination:String, headers:UnSubscribeHeaders = null):void {
            _stomp.unsubscribe(destination, headers);
        }

        public function disconnect():void {
            _stomp.disconnect();
        }

        public function get isConnected():Boolean {
            return _stomp.isConnected;
        }

        public function get sessionID():String {
            return _stomp.sessionID;
        }
    }
}
