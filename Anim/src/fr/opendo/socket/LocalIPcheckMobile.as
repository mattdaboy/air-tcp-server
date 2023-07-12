package fr.opendo.socket {
import com.distriqt.extension.networkinfo.InterfaceAddress;
import com.distriqt.extension.networkinfo.NetworkInfo;
import com.distriqt.extension.networkinfo.NetworkInterface;

import flash.events.EventDispatcher;

import fr.opendo.events.CustomEvent;

/**
 * @author Matthieu
 */
public class LocalIPcheckMobile extends EventDispatcher {
    private var hosts:Array;

    public function LocalIPcheckMobile():void {
    }

    public function check():void {
        hosts = [];
        var netInterfaces:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();

        for each (var interfaceObj:NetworkInterface in netInterfaces) {
            if (interfaceObj.active) {
                for each (var address:InterfaceAddress in interfaceObj.addresses) {
                    if (address.address == "::1" || address.address == "127.0.0.1" || address.ipVersion == "IPV6") {
                        continue;
                    }
                    hosts.push(address.address);
                }
            }
        }
        // dispatch vers Manager
        dispatchEvent(new CustomEvent(CustomEvent.HOSTS_CHECKED, [hosts]));
    }
}
}