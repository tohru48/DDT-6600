using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
	public class KickProtectBuffer : AbstractBuffer
	{
		public KickProtectBuffer(BufferInfo info)
			: base(info)
		{
		}

		public override void Start(GamePlayer player)
		{
			if (player.BufferList.GetOfType(typeof(KickProtectBuffer)) is KickProtectBuffer kickProtectBuffer)
			{
				kickProtectBuffer.Info.ValidDate += base.Info.ValidDate;
				player.BufferList.UpdateBuffer(kickProtectBuffer);
			}
			else
			{
				base.Start(player);
				player.KickProtect = true;
			}
		}

		public override void Stop()
		{
			m_player.KickProtect = false;
			base.Stop();
		}
	}
}
