using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.ServiceModel;

namespace Game.Server.WebLogin
{
	[EditorBrowsable(EditorBrowsableState.Advanced)]
	[MessageContract(IsWrapped = false)]
	[GeneratedCode("System.ServiceModel", "4.0.0.0")]
	[DebuggerStepThrough]
	public class Get_UserSexRequest
	{
		[MessageBodyMember(Name = "Get_UserSex", Namespace = "dandantang", Order = 0)]
		public Get_UserSexRequestBody Body;

		public Get_UserSexRequest()
		{
		}

		public Get_UserSexRequest(Get_UserSexRequestBody Body)
		{
			this.Body = Body;
		}
	}
}
