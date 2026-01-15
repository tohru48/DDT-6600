using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
	public class PropsBuffer : AbstractBuffer
	{
		public PropsBuffer(BufferInfo buffer)
			: base(buffer)
		{
		}

		public override void Start(GamePlayer player)
		{
			if (player.BufferList.GetOfType(typeof(PropsBuffer)) is PropsBuffer propsBuffer)
			{
				propsBuffer.Info.ValidDate += base.Info.ValidDate;
				player.BufferList.UpdateBuffer(propsBuffer);
			}
			else
			{
				base.Start(player);
				player.CanUseProp = true;
			}
		}

		public override void Stop()
		{
			m_player.CanUseProp = false;
			base.Stop();
		}
	}
}
