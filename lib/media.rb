class Media
  
  def self.init
    @@items ||= {}
    Rubygame::Mixer.open_audio(22050, Rubygame::Mixer::AUDIO_U8, 2, 8)
  end
  
  def self.load_image(path)
    @@items[path.intern] = self.store_image(path) if @@items[path.intern].nil?
    @@items[path.intern]
  end
  
  def self.load_sound(path)
    @@items[path.intern] = self.store_sound(path) if @@items[path.intern].nil?
    @@items[path.intern]
  end
  
  def self.store_image(path)
    # use mediabag
    Rubygame::Surface.load_image(path)
  end
  
  def self.store_sound(path)
    Rubygame::Mixer::Sample.load_audio(path)
  end
  
end