package fr.opendo.socket {
import flash.events.EventDispatcher;
import flash.net.InterfaceAddress;
import flash.net.NetworkInfo;
import flash.net.NetworkInterface;

import fr.opendo.events.CustomEvent;

/**
 * @author Matthieu
 */
public class LocalIPcheck extends EventDispatcher {
    private var hosts:Array;

    public function LocalIPcheck():void {
    }

    public function check():void {
        hosts = [];
        var netInterfaces:Vector.<NetworkInterface> = Vector.<NetworkInterface>(NetworkInfo.networkInfo.findInterfaces());

        if (netInterfaces && netInterfaces.length > 0) {
            for each (var interfaceObj:NetworkInterface in netInterfaces) {
                if (interfaceObj.active) {
                    var addresses:Vector.<InterfaceAddress> = Vector.<InterfaceAddress>(interfaceObj.addresses);
                    for each (var address:InterfaceAddress in addresses) {
                        // Debug.display("Address IP = " + address.address);
                        if (address.address == "::1" || address.address == "127.0.0.1" || address.ipVersion == "IPV6") {
                            continue;
                        }
                        hosts.push(address.address);
                        // Debug.display("Address ipversion = " + address.ipVersion);
                    }
                }
            }
        }

        // dispatch vers Manager
        dispatchEvent(new CustomEvent(CustomEvent.HOSTS_CHECKED, [hosts]));
    }
}
}