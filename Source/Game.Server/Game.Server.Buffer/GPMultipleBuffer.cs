using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
	public class GPMultipleBuffer : AbstractBuffer
	{
		public GPMultipleBuffer(BufferInfo info)
			: base(info)
		{
		}

		public override void Start(GamePlayer player)
		{
			if (player.BufferList.GetOfType(typeof(GPMultipleBuffer)) is GPMultipleBuffer gPMultipleBuffer)
			{
				gPMultipleBuffer.Info.ValidDate += base.Info.ValidDate;
				player.BufferList.UpdateBuffer(gPMultipleBuffer);
			}
			else
			{
				base.Start(player);
				player.double_0 *= base.Info.Value;
			}
		}

		public override void Stop()
		{
			if (m_player != null)
			{
				m_player.double_0 /= base.Info.Value;
				base.Stop();
			}
		}
	}
}
