package com.hydraframework.plugins.authentication.controller
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;
	import com.hydraframework.plugins.authentication.data.interfaces.IIdentityDelegate;
	import com.hydraframework.plugins.authentication.model.PrincipalProxy;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class LogoutCommand extends SimpleCommand implements IResponder
	{
		public function get delegate():IIdentityDelegate
		{
			return this.facade.retrieveDelegate(IIdentityDelegate) as IIdentityDelegate;
		}

		public function get proxy():PrincipalProxy
		{
			return PrincipalProxy(this.facade.retrieveProxy(PrincipalProxy.NAME));
		}

		public function LogoutCommand(facade:IFacade)
		{
			super(facade);
		}

		override public function execute(notification:Notification):void
		{
			if (notification.isRequest())
			{
				var asyncToken:AsyncToken=this.delegate.logout();
				asyncToken.addResponder(this);
			}
		}
		
		public function result(data:Object):void {
			if (Boolean(data.result))
			{
				this.proxy.logOut();
			}
		}
		
		public function fault(data:Object):void {
		}
		
	}
}