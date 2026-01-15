using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
	public class AgiBuffer : AbstractBuffer
	{
		public AgiBuffer(BufferInfo buffer)
			: base(buffer)
		{
		}

		public override void Start(GamePlayer player)
		{
			if (player.BufferList.GetOfType(typeof(AgiBuffer)) is AgiBuffer agiBuffer)
			{
				agiBuffer.Info.ValidDate += base.Info.ValidDate;
				if (agiBuffer.Info.ValidDate > 30)
				{
					agiBuffer.Info.ValidDate = 30;
				}
				player.BufferList.UpdateBuffer(agiBuffer);
			}
			else
			{
				base.Start(player);
				player.PlayerCharacter.AgiAddPlus = base.Info.Value;
			}
		}

		public override void Stop()
		{
			m_player.PlayerCharacter.AgiAddPlus = 0;
			base.Stop();
		}
	}
}
