init()
{
	level thread on_player_connect();
}

IsSliding() //You can use this function like BO3/BO4/BOCW's IsSliding() function to check if the player is sliding.
{
	if(is_true(self.isSliding))
		return true;
	return false;
}

on_player_connect()
{
	level endon("end_game");
	while(1)
	{
		level waittill("connected", player);
		player thread ready_to_slide();
	}
}

ready_to_slide()
{
	self.isSliding = false;
	self.isReadyToSlide = true;
	while(1)
	{
		if(self IsSprinting() && self IsOnGround())
		{
			while(self IsSprinting())
			{
				wait .01;
			}
			if(!self IsOnGround())
			{
				while(!self IsOnGround())
				{
					wait .01;
				}
			}
			self knee_slide();
		}
		wait .01;
	}
}

knee_slide()
{
	if(self GetStance() == "crouch" && !self.Sliding && self.isReadyToSlide)
	{
		self.is_sliding = true;
		self.isReadyToSlide = false;
		self.is_drinking = 1;
		self SetStance( "crouch" );
		self AllowProne(false);
		self AllowAds(false);
		self AllowMelee(false);
		self do_knee_slide(300,1);
		self.is_drinking = undefined;
		self.isSliding = false;
		self AllowAds(true);
		self AllowMelee(true);
		self AllowProne(true);
		self.isReadyToSlide = true;
	}
}

do_knee_slide(force,time)
{
	angles = self GetPlayerAngles();
	angles = (0,(angles[1]),0);
	vec = AnglesToForward(angles);
	i = 0;
	time = time*0.18;
	dist = 20;
	while(i < time && self IsOnGround() && dist > 5)
	{
		if(self GetStance() == "stand")
		{
			self thread doAJump();
			return;
		}
		mo = self.origin;
		i += 0.01;
		wait 0.01;
		self SetVelocity(vec * force);
		dist = Distance(mo, self.origin);
	}
}

doAJump()
{
	direction = AnglesToUp((0,self GetPlayerAngles()[1],0) * 2000);
	self SetOrigin(self.origin + (0,0,5));
	self SetVelocity( self GetVelocity() + (0,0,250) );
	wait .1;
	while(!self IsOnGround())
	{
		wait .01;
	}
	self knee_slide();
}
