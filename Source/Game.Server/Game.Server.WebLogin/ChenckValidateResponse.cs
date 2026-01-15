using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.ServiceModel;

namespace Game.Server.WebLogin
{
	[EditorBrowsable(EditorBrowsableState.Advanced)]
	[MessageContract(IsWrapped = false)]
	[DebuggerStepThrough]
	[GeneratedCode("System.ServiceModel", "4.0.0.0")]
	public class ChenckValidateResponse
	{
		[MessageBodyMember(Name = "ChenckValidateResponse", Namespace = "dandantang", Order = 0)]
		public ChenckValidateResponseBody Body;

		public ChenckValidateResponse()
		{
		}

		public ChenckValidateResponse(ChenckValidateResponseBody Body)
		{
			this.Body = Body;
		}
	}
}
