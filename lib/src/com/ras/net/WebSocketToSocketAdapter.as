package com.ras.net {
    import com.worlize.websocket.WebSocket;
    import com.worlize.websocket.WebSocketErrorEvent;
    import com.worlize.websocket.WebSocketEvent;

    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;

    import flash.net.Socket;
    import flash.utils.ByteArray;

    public class WebSocketToSocketAdapter extends Socket {
        private var _instance:WebSocket;
        private var _dataInput:ByteArray;
        private var _dataOutput:ByteArray;

        public function WebSocketToSocketAdapter(instance:WebSocket) {
            _instance = instance;
            _dataInput = new ByteArray();
            _dataOutput = new ByteArray();

            instance.addEventListener(WebSocketEvent.OPEN, openHandler);
            instance.addEventListener(WebSocketEvent.CLOSED, closedHandler);
            instance.addEventListener(WebSocketEvent.MESSAGE, messageHandler);
            instance.addEventListener(WebSocketErrorEvent.CONNECTION_FAIL, ioErrorHandler);
            instance.addEventListener(WebSocketErrorEvent.ABNORMAL_CLOSE, ioErrorHandler);
            instance.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
            instance.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
        }

        private function openHandler(e:Event = null):void {
            dispatchEvent(new Event(Event.CONNECT));
        }

        private function closedHandler(e:Event = null):void {
            dispatchEvent(new Event(Event.CLOSE));
        }

        private function messageHandler(e:WebSocketEvent = null):void {
            _dataInput = e.message.binaryData;
            dispatchEvent(new ProgressEvent(ProgressEvent.SOCKET_DATA));
        }

        private function ioErrorHandler(e:Event = null):void {
            dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
        }

        override public function get bytesAvailable():uint {
            return _dataInput.bytesAvailable;
        }

        override public function get connected():Boolean {
            return _instance.connected;
        }

        override public function close():void {
            return _instance.close();
        }

        override public function flush():void {
            _instance.sendBytes(_dataOutput);
            _dataOutput.clear();
        }

        override public function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void {
            _dataInput.readBytes(bytes, offset, length);
        }

        override public function connect(host:String, port:int):void {
            _instance.connect();
        }

        override public function writeBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void {
            _dataOutput.writeBytes(bytes, offset, length);
        }
    }
}
