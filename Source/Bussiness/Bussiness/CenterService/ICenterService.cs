// Decompiled with JetBrains decompiler
// Type: Bussiness.CenterService.ICenterService
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using System.CodeDom.Compiler;
using System.ServiceModel;

#nullable disable
namespace Bussiness.CenterService
{
    [ServiceContract(ConfigurationName = "CenterService.ICenterService")]
    [GeneratedCode("System.ServiceModel", "4.0.0.0")]
    public interface ICenterService
    {
        [OperationContract(Action = "http://tempuri.org/ICenterService/ActiveEvent", ReplyAction = "http://tempuri.org/ICenterService/ActiveEventResponse")]
        bool ActiveEvent(int type, string id);

        [OperationContract(Action = "http://tempuri.org/ICenterService/GetServerList", ReplyAction = "http://tempuri.org/ICenterService/GetServerListResponse")]
        ServerData[] GetServerList();

        [OperationContract(Action = "http://tempuri.org/ICenterService/ChargeMoney", ReplyAction = "http://tempuri.org/ICenterService/ChargeMoneyResponse")]
        bool ChargeMoney(int userID, string chargeID);

        [OperationContract(Action = "http://tempuri.org/ICenterService/SystemNotice", ReplyAction = "http://tempuri.org/ICenterService/SystemNoticeResponse")]
        bool SystemNotice(string msg);

        [OperationContract(Action = "http://tempuri.org/ICenterService/RemoteServer", ReplyAction = "http://tempuri.org/ICenterService/RemoteServerResponse")]
        bool RemoteServer(int ProcID, string privateKey);

        [OperationContract(Action = "http://tempuri.org/ICenterService/KitoffUser", ReplyAction = "http://tempuri.org/ICenterService/KitoffUserResponse")]
        bool KitoffUser(int playerID, string msg);

        [OperationContract(Action = "http://tempuri.org/ICenterService/ReLoadServerList", ReplyAction = "http://tempuri.org/ICenterService/ReLoadServerListResponse")]
        bool ReLoadServerList();

        [OperationContract(Action = "http://tempuri.org/ICenterService/MailNotice", ReplyAction = "http://tempuri.org/ICenterService/MailNoticeResponse")]
        bool MailNotice(int playerID);

        [OperationContract(Action = "http://tempuri.org/ICenterService/ActivePlayer", ReplyAction = "http://tempuri.org/ICenterService/ActivePlayerResponse")]
        bool ActivePlayer(bool isActive);

        [OperationContract(Action = "http://tempuri.org/ICenterService/CreatePlayer", ReplyAction = "http://tempuri.org/ICenterService/CreatePlayerResponse")]
        bool CreatePlayer(int id, string name, string password, bool isFirst);

        [OperationContract(Action = "http://tempuri.org/ICenterService/ValidateLoginAndGetID", ReplyAction = "http://tempuri.org/ICenterService/ValidateLoginAndGetIDResponse")]
        bool ValidateLoginAndGetID(string name, string password, ref int userID, ref bool isFirst);

        [OperationContract(Action = "http://tempuri.org/ICenterService/AASUpdateState", ReplyAction = "http://tempuri.org/ICenterService/AASUpdateStateResponse")]
        bool AASUpdateState(bool state);

        [OperationContract(Action = "http://tempuri.org/ICenterService/AASGetState", ReplyAction = "http://tempuri.org/ICenterService/AASGetStateResponse")]
        int imethod_0();

        [OperationContract(Action = "http://tempuri.org/ICenterService/ExperienceRateUpdate", ReplyAction = "http://tempuri.org/ICenterService/ExperienceRateUpdateResponse")]
        int ExperienceRateUpdate(int serverId);

        [OperationContract(Action = "http://tempuri.org/ICenterService/NoticeServerUpdate", ReplyAction = "http://tempuri.org/ICenterService/NoticeServerUpdateResponse")]
        int NoticeServerUpdate(int serverId, int type);

        [OperationContract(Action = "http://tempuri.org/ICenterService/UpdateConfigState", ReplyAction = "http://tempuri.org/ICenterService/UpdateConfigStateResponse")]
        bool UpdateConfigState(int type, bool state);

        [OperationContract(Action = "http://tempuri.org/ICenterService/GetConfigState", ReplyAction = "http://tempuri.org/ICenterService/GetConfigStateResponse")]
        int GetConfigState(int type);

        [OperationContract(Action = "http://tempuri.org/ICenterService/Reload", ReplyAction = "http://tempuri.org/ICenterService/ReloadResponse")]
        bool Reload(string type);

        [OperationContract(Action = "http://tempuri.org/ICenterService/AASGetState", ReplyAction = "http://tempuri.org/ICenterService/AASGetStateResponse")]
        int AASGetState();
    }
}
