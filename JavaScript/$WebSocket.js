mainServices.factory('$WebSocket', ['$q', '$rootScope', '$timeout',
    function($q, $rootScope, $timeout){
        var $this = {
            webSocket: null,
            observers: {},
            callbacks: {},
            register: function(url, id, callbacks){
                if (!$this.webSocket){
                    $this.webSocket = new WebSocket(url);
                    $this.webSocket.onopen = function(event){ console.log('Connected to server...', event); };
                    $this.webSocket.onclose = function(event){ console.log('Connection to server was lost...', event); };
                    $this.webSocket.onerror = function(event){ console.error(event); };
                    $this.webSocket.onmessage = function(message){ listener(message, 'onmessage'); };
                }

                id = id || generateUUID();
                $this.observers[id] = callbacks;
                return id;
            },
            send: function(request){
                if (typeof request === 'string'){ request = { message: request }; }
                var defer = $q.defer(), callbackId = generateUUID();
                $this.callbacks[callbackId] = { time: new Date(), callback: defer };
                request.callback_id = callbackId;
                if ($this.webSocket.readyState === 1){ processRequest(request); }
                else { wait(function(){ processRequest(request); }); }
                return defer.promise;
            }
        };
        
        function wait(callback){
            console.log('Waiting for connection...', $this.webSocket);
            $timeout(function(){
                if ($this.webSocket.readyState === 1){ callback(); }
                else { wait(callback); }
            }, 5);
        }
        
        function processRequest(request){
            console.log('Sending request...', request);
            $this.webSocket.send(JSON.stringify(request));
        }
        
        function listener(response, action){
            console.log('Message recieved...', response);
            if ($this.callbacks[response.callback_id]){
                console.log($this.callbacks[response.callback_id]);
                $rootScope.$apply($this.callbacks[response.callback_id].callback.resolve(response.data));
                delete $this.callbacks[response.callbackID];
            }
            notifyAll(JSON.parse(response.data), action);
        }
        
        function notify(response, action, id){
            if ($this.observers[id] && $this.observers[id][action] && angular.isFunction($this.observers[id][action])){
                $this.observers[id][action](response);
            }
        }
        
        function notifyAll(response, action){
            for (var id in $this.observers){ notify(response, action, id); }
        }
        
        return $this;
}]);

    <listener>
        <listener-class>com.harrislogic.stella.notification.MessageServerEndpoint</listener-class>
    </listener>
