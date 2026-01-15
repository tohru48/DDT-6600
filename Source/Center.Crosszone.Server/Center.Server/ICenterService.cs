using System;
using System.Collections.Generic;
using System.ServiceModel;
namespace Center.Server
{
	[ServiceContract]
	public interface ICenterService
	{
		[OperationContract]
		bool ActiveEvent(int type, string id);
		[OperationContract]
		System.Collections.Generic.List<ServerData> GetServerList();
		[OperationContract]
		bool ChargeMoney(int userID, string chargeID);
		[OperationContract]
		bool SystemNotice(string msg);
		[OperationContract]
		bool RemoteServer(int ProcID, string privateKey);
		[OperationContract]
		bool KitoffUser(int playerID, string msg);
		[OperationContract]
		bool ReLoadServerList();
		[OperationContract]
		bool MailNotice(int playerID);
		[OperationContract]
		bool ActivePlayer(bool isActive);
		[OperationContract]
		bool CreatePlayer(int id, string name, string password, bool isFirst);
		[OperationContract]
		bool ValidateLoginAndGetID(string name, string password, ref int userID, ref bool isFirst);
		[OperationContract]
		bool AASUpdateState(bool state);
		[OperationContract]
		int imethod_0();
		[OperationContract]
		int ExperienceRateUpdate(int serverId);
		[OperationContract]
		int NoticeServerUpdate(int serverId, int type);
		[OperationContract]
		bool UpdateConfigState(int type, bool state);
		[OperationContract]
		int GetConfigState(int type);
		[OperationContract]
		bool Reload(string type);
	}
}
