using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
	public class DameBuffer : AbstractBuffer
	{
		public DameBuffer(BufferInfo buffer)
			: base(buffer)
		{
		}

		public override void Start(GamePlayer player)
		{
			if (player.BufferList.GetOfType(typeof(DameBuffer)) is DameBuffer dameBuffer)
			{
				dameBuffer.Info.ValidDate += base.Info.ValidDate;
				if (dameBuffer.Info.ValidDate > 30)
				{
					dameBuffer.Info.ValidDate = 30;
				}
				player.BufferList.UpdateBuffer(dameBuffer);
			}
			else
			{
				base.Start(player);
				player.PlayerCharacter.DameAddPlus = base.Info.Value;
			}
		}

		public override void Stop()
		{
			m_player.PlayerCharacter.DameAddPlus = 0;
			base.Stop();
		}
	}
}
