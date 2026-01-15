using System.CodeDom.Compiler;
using System.Diagnostics;
using System.ServiceModel;
using System.ServiceModel.Channels;

#nullable disable
namespace Bussiness.CenterService
{
    [DebuggerStepThrough]
    [GeneratedCode("System.ServiceModel", "4.0.0.0")]
    public class CenterServiceClient : ClientBase<ICenterService>, ICenterService
    {
        public CenterServiceClient()
        {
        }

        public CenterServiceClient(string endpointConfigurationName)
          : base(endpointConfigurationName)
        {
        }

        public CenterServiceClient(string endpointConfigurationName, string remoteAddress)
          : base(endpointConfigurationName, remoteAddress)
        {
        }

        public CenterServiceClient(string endpointConfigurationName, EndpointAddress remoteAddress)
          : base(endpointConfigurationName, remoteAddress)
        {
        }

        public CenterServiceClient(Binding binding, EndpointAddress remoteAddress)
          : base(binding, remoteAddress)
        {
        }

        public bool ActiveEvent(int type, string id) => this.Channel.ActiveEvent(type, id);

        public ServerData[] GetServerList() => this.Channel.GetServerList();

        public bool ChargeMoney(int userID, string chargeID)
        {
            return this.Channel.ChargeMoney(userID, chargeID);
        }

        public bool SystemNotice(string msg) => this.Channel.SystemNotice(msg);

        public bool RemoteServer(int ProcID, string privateKey)
        {
            return this.Channel.RemoteServer(ProcID, privateKey);
        }

        public bool KitoffUser(int playerID, string msg) => this.Channel.KitoffUser(playerID, msg);

        public bool ReLoadServerList() => this.Channel.ReLoadServerList();

        public bool MailNotice(int playerID) => this.Channel.MailNotice(playerID);

        public bool ActivePlayer(bool isActive) => this.Channel.ActivePlayer(isActive);

        public bool CreatePlayer(int id, string name, string password, bool isFirst)
        {
            return this.Channel.CreatePlayer(id, name, password, isFirst);
        }

        public bool ValidateLoginAndGetID(
          string name,
          string password,
          ref int userID,
          ref bool isFirst)
        {
            return this.Channel.ValidateLoginAndGetID(name, password, ref userID, ref isFirst);
        }

        public bool AASUpdateState(bool state) => this.Channel.AASUpdateState(state);

        public int imethod_0() => this.Channel.imethod_0();

        public int ExperienceRateUpdate(int serverId) => this.Channel.ExperienceRateUpdate(serverId);

        public int NoticeServerUpdate(int serverId, int type)
        {
            return this.Channel.NoticeServerUpdate(serverId, type);
        }

        public bool UpdateConfigState(int type, bool state)
        {
            return this.Channel.UpdateConfigState(type, state);
        }

        public int GetConfigState(int type) => this.Channel.GetConfigState(type);

        public bool Reload(string type) => this.Channel.Reload(type);

        public int AASGetState() => this.Channel.AASGetState();
    }
}
