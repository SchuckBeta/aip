package com.oseasy.initiate.test;


import java.net.URI;


import javax.websocket.ClientEndpoint;
import javax.websocket.ContainerProvider;
import javax.websocket.Session;
import javax.websocket.WebSocketContainer;


@ClientEndpoint
public class WebSocketTest {


    private String deviceId;


    public WebSocketTest () {
        
    }

    public WebSocketTest (String deviceId) {
        this.deviceId = deviceId;
    }

    protected boolean start() {
        WebSocketContainer Container = ContainerProvider.getWebSocketContainer();
        String uri = "ws://localhost/websocket?userid=2c0cda19b85e42beb32a176838a7f054";
        System.out.println("Connecting to " + uri);
        try {
            Container.connectToServer(WebSocketTest.class, URI.create(uri));
            System.out.println("count: " + deviceId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    public static void main(String[] args) {
        for (int i = 1; i< 150000; i++) {
            WebSocketTest wSocketTest = new WebSocketTest(String.valueOf(i));
            if (!wSocketTest.start()) {
            	try {
					Thread.sleep(1000000000000000L);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
            }
        }
    }
}