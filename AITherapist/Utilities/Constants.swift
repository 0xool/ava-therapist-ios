//
//  Constants.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 10/11/23.
//

import Foundation

struct Constants {
    static let test = false
    static let WebProtocol = test ? "http://" : "https://"
    static let BaseUrl = test ? "localhost" : "aitherapist.online"
    
    static let port = ":3000/"
    static private let sendConversationUrl = "/therapistAnswer"
    static let SendConversationUrl: String = BaseUrl + sendConversationUrl
    
    static let MainUrl = WebProtocol + BaseUrl + port
    static let bgQueue = DispatchQueue(label: "bg_parse_queue")
    static let testQueue = DispatchQueue(label: "test")
    
    static let EmergencyPhoneNumber = "988"
    static let InitialChatMessageBubbles: [String] = ["Experiencing stress right now", "Feeling down and need to talk", "Having trouble sleeping", "Feeling hopeless or lost", "Feeling grateful and blessed", "Excited and motivated"]
}
//======================================================================================================
extension Constants {
    static let todaysFacts: [TodaysFactsCategory:[String]] = [
        .AboutYourself: [
            "Your favorite color influences your mood and emotions.",
            "Smiling can improve your mood and the mood of those around you.",
            "Your taste preferences are influenced by both genetics and experiences.",
            "You have a unique fingerprint that no one else in the world shares.",
            "Laughter is a natural stress reliever and can boost your immune system.",
            "Your dreams are often a reflection of your subconscious thoughts.",
            "Each cell in your body contains a complete set of your DNA.",
            "Your brain generates about 70,000 thoughts on an average day.",
            "Your body is constantly renewing its cells; you get a new stomach lining every few days.",
            "Your sense of smell is strongly connected to memory and emotions.",
            "The music you listen to can evoke specific emotions and memories.",
            "Your handwriting is as unique as your fingerprint.",
            "The dreams you remember are only a fraction of what your brain produces during sleep.",
            "Your body has a natural preference for certain sleeping positions.",
            "Your sense of humor is influenced by cultural and personal experiences.",
            "The unique combination of your genes determines your physical appearance.",
            "Your body has a built-in temperature regulation system to maintain homeostasis.",
            "Your voice changes throughout your life due to factors like age and environment.",
            "The foods you enjoy are influenced by both genetics and cultural exposure.",
            "Your gut microbiome plays a crucial role in digestion and overall health.",
        ],
        
            .LifeAndExistence: [
                "The Earth is approximately 4.5 billion years old.",
                "Trees produce oxygen through a process called photosynthesis.",
                "Every living thing is made up of cells, the basic units of life.",
                "The speed of light is about 299,792 kilometers per second.",
                "Human DNA is over 99% identical to every other human.",
                "The universe is expanding, and galaxies are moving away from each other.",
                "Water makes up about 60% of the human body.",
                "The moon influences the Earth's tides due to gravitational forces.",
                "The concept of time is relative and can vary depending on your speed and gravity.",
                "The energy in your body is a result of the food you consume.",
                "Quantum entanglement suggests particles can be connected regardless of distance.",
                "The concept of time dilation occurs in extreme gravitational fields.",
                "In space, time moves differently due to the theory of relativity.",
                "The Earth's magnetic field protects the planet from solar wind.",
                "Your body is composed of elements forged in stars through nuclear fusion.",
                "The double-slit experiment demonstrates the wave-particle duality of light.",
                "Chaos theory explores the sensitive dependence on initial conditions.",
                "The Fibonacci sequence is a naturally occurring mathematical pattern.",
                "Dark matter, although invisible, is believed to make up a significant portion of the universe.",
                "Your body produces melatonin to regulate sleep-wake cycles.",
            ],
        
            .MindAndConsciousness: [
                "Your brain generates electrical impulses that create your thoughts.",
                "Meditation can positively impact brain structure and function.",
                "The brain can change and adapt throughout your life; this is called neuroplasticity.",
                "Emotions are complex biochemical reactions in your brain.",
                "The placebo effect is a real phenomenon, where belief in a treatment can cause improvement.",
                "Neurotransmitters like dopamine and serotonin play a crucial role in mood.",
                "Memories are not perfect; they can be influenced by various factors.",
                "The brain consumes about 20% of the body's total energy.",
                "Humans have the ability to form abstract thoughts and ideas.",
                "Your perception of reality is a combination of sensory input and cognitive interpretation.",
                "The brain's default mode network is active when your mind wanders or daydreams.",
                "Brainwaves change during different states of consciousness, such as sleep and meditation.",
                "The brain's gray matter density can change with meditation practice.",
                "Mirror neurons allow you to understand and mimic others' actions.",
                "The brain can generate spontaneous moments of insight and creativity.",
                "The placebo effect involves the brain releasing endorphins and natural painkillers.",
                "Deja vu may occur when there is a brief disruption in memory formation.",
                "Neurotransmitters like oxytocin contribute to feelings of bonding and connection.",
                "The brain has a negativity bias, focusing more on negative experiences.",
                "The brain can create false memories based on suggestion and misinformation.",
            ],
        
            .HealthandWellbeing: [
                "Regular physical activity is essential for overall health and longevity.",
                "Adequate sleep is crucial for memory consolidation and overall well-being.",
                "The body has a natural circadian rhythm that influences sleep-wake cycles.",
                "Chronic stress can have negative effects on both physical and mental health.",
                "Hydration is vital for various bodily functions, including digestion and temperature regulation.",
                "Balanced nutrition is essential for optimal physical and mental performance.",
                "The body's immune system defends against infections and diseases.",
                "Deep breathing can activate the parasympathetic nervous system, promoting relaxation.",
                "Maintaining social connections is linked to better mental health.",
                "Positive thinking can have a beneficial impact on overall well-being.",
                "Sunlight exposure triggers the production of vitamin D in your skin.",
                "The body's immune system can remember previous infections for faster response.",
                "Hormones like adrenaline prepare your body for the `fight or flight` response.",
                "The body undergoes continuous cellular repair during sleep.",
                "The placebo effect can be influenced by the color of pills.",
                "The body has a built-in stress response to cope with challenges.",
                "Chronic inflammation is linked to various health conditions.",
                "The body releases endorphins during exercise, contributing to the `runner's high.`",
                "The body's pH level is carefully regulated for optimal function.",
                "Yawning may help cool the brain and increase alertness.",
            ],
        .HumanConnections: [
            "Non-verbal communication, such as body language, plays a significant role in interactions.",
            "Empathy allows you to understand and share the feelings of others.",
            "Humans are social beings, and social bonds are crucial for mental health.",
            "Acts of kindness, even small ones, can create a positive ripple effect.",
            "Your relationships with others can influence your own personal growth.",
            "Shared laughter strengthens social bonds and promotes a sense of belonging.",
            "Forgiveness is a powerful tool for personal and interpersonal healing.",
            "Expressing gratitude can enhance your overall sense of well-being.",
            "The ability to listen actively is a key component of effective communication.",
            "Collaborative efforts often lead to more successful outcomes than individual efforts.",
            "Hugs can trigger the release of oxytocin, promoting bonding.",
            "The sense of touch is crucial for emotional and physical well-being.",
            "The act of giving activates the brain's reward center.",
            "The brain can simulate the feelings of empathy by observing others.",
            "Dogs' oxytocin levels increase when they make eye contact with humans.",
            "Human babies are born with the ability to mimic facial expressions.",
            "Laughter is a social behavior that strengthens social bonds.",
            "Acts of kindness can lead to an increase in serotonin levels.",
            "The brain processes social rejection similarly to physical pain.",
            "The `six degrees of separation` theory suggests everyone is connected by a chain of acquaintances.",
        ],
        .LearningandGrowth: [
            "Curiosity is a natural human trait that drives learning and exploration.",
            "Failure is a part of the learning process and can lead to valuable lessons.",
            "Reading regularly stimulates the brain and broadens your perspective.",
            "Your mindset can influence your ability to learn and adapt.",
            "Lifelong learning contributes to cognitive health and personal fulfillment.",
            "Setting specific and achievable goals increases your chances of success.",
            "Creativity involves connecting seemingly unrelated ideas and concepts.",
            "Continuous self-reflection fosters personal growth and self-awareness.",
            "Challenges and obstacles are opportunities for personal development.",
            "Developing a growth mindset allows for resilience and adaptability.",
            "The brain forms new neural connections when learning something new.",
            "Sleep is essential for memory consolidation and learning retention.",
            "The brain's prefrontal cortex, responsible for decision-making, continues developing into your 20s.",
            "The brain's ability to create new neurons is known as neurogenesis.",
            "Synesthesia is a condition where senses overlap, allowing people to `see` sounds or `taste` colors.",
            "Curiosity is associated with increased activity in the brain's reward system.",
            "Humans have a natural inclination to seek patterns and connections.",
            "Neuroplasticity allows the brain to reorganize itself based on experiences.",
            "The brain uses both hemispheres to process information, dispelling the myth of left-brain/right-brain dominance.",
            "Epigenetics explores how external factors can influence gene expression.",
        ],
        
            .NatureandEnvironment: [
                "Biodiversity is essential for the health of ecosystems and the planet.",
                "Human activities, such as deforestation and pollution, impact the environment.",
                "The Earth's climate is changing due to human-induced factors.",
                "Conservation efforts are crucial to protect endangered species and habitats.",
                "The interconnectedness of ecosystems highlights the importance of balance.",
                "Sustainable practices promote the responsible use of natural resources.",
                "Nature has therapeutic benefits and can reduce stress and anxiety.",
                "The water cycle plays a vital role in maintaining life on Earth.",
                "Renewable energy sources contribute to reducing environmental impact.",
                "Taking small steps, such as reducing waste, can collectively make a significant impact.",
                "The Amazon rainforest produces about 20% of the world's oxygen.",
                "The Earth's ozone layer protects life by absorbing harmful ultraviolet radiation.",
                "Geothermal energy taps into the Earth's internal heat for power generation.",
                "The Earth's magnetic poles undergo periodic reversals over geological time.",
                "Coral reefs, known as the `rainforests of the sea,` support diverse marine life.",
                "The Earth's atmosphere is composed of nitrogen, oxygen, and trace gases.",
                "The water cycle involves processes like evaporation, condensation, and precipitation.",
                "Earth experiences seasonal changes due to its axial tilt.",
                "Wind energy harnesses the kinetic energy of moving air for electricity.",
                "The butterfly effect suggests small actions can lead to significant consequences.",
            ],
        .CulturalandGlobalAwareness: [
            "Cultural diversity enriches human experiences and perspectives.",
            "Cultural appreciation involves understanding and respecting different customs and traditions.",
            "Global interconnectedness means that actions in one part of the world can impact others.",
            "Technology has facilitated global communication and collaboration.",
            "The pursuit of peace and understanding fosters global harmony.",
            "International cooperation is essential for addressing global challenges.",
            "Awareness of historical events helps shape a more informed perspective.",
            "Education is a powerful tool for promoting tolerance and empathy.",
            "Empowering marginalized communities is crucial for achieving social justice.",
            "Acts of kindness and compassion can bridge cultural divides.",
            "Human languages have common linguistic features across diverse cultures.",
            "The Universal Declaration of Human Rights emphasizes fundamental rights for all.",
            "The concept of time varies across cultures, influencing perceptions and priorities.",
            "Artistic expressions provide insight into cultural values and perspectives.",
            "The Silk Road facilitated cultural exchange between East and West.",
            "Cultural diffusion refers to the spread of cultural elements between different societies.",
            "The concept of karma in Eastern philosophies emphasizes cause and effect.",
            "The Golden Rule, found in various cultures, encourages empathy and kindness.",
            "The concept of `Ubuntu` in African philosophy emphasizes interconnectedness.",
            "Cultural intelligence involves understanding and adapting to diverse cultural contexts.",
        ],
        .TimeandPerspective: [
            "Time is a finite resource, so how you spend it is significant.",
            "Setting priorities helps you allocate time to what truly matters to you.",
            "The past has shaped who you are, but the present is where you have the most influence.",
            "Embracing change is a natural part of personal and societal evolution.",
            "The future is uncertain, but your actions today can shape a positive tomorrow.",
            "Reflecting on past experiences can provide valuable insights for personal growth.",
            "Balancing short-term pleasures with long-term goals contributes to fulfillment.",
            "Time management involves both efficiency and effectiveness.",
            "Mindful living encourages being fully present in each moment.",
            "The concept of time is subjective and can be influenced by perception.",
            "The concept of time travel is explored in theoretical physics.",
            "Time perception can be influenced by attention and focus.",
            "Eternalism suggests that past, present, and future events all exist simultaneously.",
            "The present moment is the only moment you can truly experience.",
            "Time seems to pass more quickly as you age due to relative comparison.",
            "The `arrow of time` reflects the unidirectional flow from past to future.",
            "The concept of time zones helps standardize time across the globe.",
            "Some cultures view time as a cyclical, repeating pattern.",
            "The idea of \"time flies when you're having fun\" reflects the subjective nature of time.",
            "The concept of \"flow\" describes a state of total immersion and focus in an activity.",
        ],
        .TechnologyandInnovation: [
            "Technology has transformed the way information is accessed and shared.",
            "Ethical considerations in technology development are crucial for societal well-being.",
            "Digital literacy is essential for navigating the complexities of the online world.",
            "Innovations in healthcare have significantly improved the quality of life.",
            "Responsible technology use involves considering its environmental impact.",
            "The potential of artificial intelligence raises ethical questions about its use.",
            "Connectivity through technology enables global collaboration and communication.",
            "Innovation often arises from a combination of creativity and problem-solving.",
            "Technology can both connect and disconnect people, depending on its use.",
            "Ethical considerations and mindful use are important aspects of technological advancement.",
            "The Turing Test assesses a machine's ability to exhibit human-like intelligence.",
            "Augmented reality overlays digital information on the physical world.",
            "The Internet of Things (IoT) connects everyday objects to the internet for data exchange.",
            "Quantum computing utilizes principles of quantum mechanics for advanced computation.",
            "The \"uncanny valley\" suggests discomfort when robots closely resemble humans.",
            "Nanotechnology involves manipulating materials at the molecular or atomic level.",
            "3D printing creates objects layer by layer from digital models.",
            "Virtual reality immerses users in computer-generated environments.",
            "The \"butterfly keyboard effect\" refers to the design challenges in ultra-thin laptops.",
            "The potential for self-driving cars raises ethical and safety considerations.",
        ]
    ]
    
    enum TodaysFactsCategory: String {
        case AboutYourself = "About Yourself"
        case LifeAndExistence = "Life and Existence"
        case MindAndConsciousness = "Mind and Consciousness"
        
        case HealthandWellbeing = "Health and Well-being"
        case HumanConnections = "Human Connections"
        case LearningandGrowth = "Learning and Growth"
        
        case NatureandEnvironment = "Nature and Environment"
        case CulturalandGlobalAwareness = "Cultural and Global Awareness"
        case TimeandPerspective = "Time and Perspective"
        
        case TechnologyandInnovation = "Technology and Innovation"
    }
}

//======================================================================================================
extension Constants {
    static let dailyTasks = [
        "Hold the door open for someone and greet them with a smile.",
        "Compliment a stranger on something you genuinely appreciate about them.",
        "Leave a small uplifting note in a public place for someone to find.",
        "Strike up a friendly conversation with a cashier or service worker.",
        "Offer your seat to someone on public transportation.",
        "Pay for the coffee or meal of the person behind you in line.",
        "Help someone struggling with heavy bags or a difficult task.",
        "Write a positive message on a sidewalk or a public space with chalk.",
        "Leave an encouraging note in a library book for the next reader.",
        "Smile at someone passing by and say, \"Have a great day!\"",
        "Share a snack or treat with a coworker or classmate.",
        "Give a genuine compliment to a stranger about their choice of clothing.",
        "Offer directions or assistance to someone who looks lost.",
        "Donate to a charity or cause that supports strangers in need.",
        "Strike up a conversation with someone waiting in line and find common ground.",
        "Leave a kind review for a local business or service you appreciate.",
        "Share an umbrella or offer shelter to someone caught in the rain.",
        "Write a positive message on a sticky note and leave it on a public bulletin board.",
        "Express gratitude to a janitor, maintenance worker, or other behind-the-scenes staff.",
        "Start a conversation with a neighbor you haven't spoken to before.",
        "Pick up litter in a public space to contribute to a cleaner environment.",
        "Share extra produce from your garden with neighbors or passersby.",
        "Offer to take a photo for a group of people who are struggling with a selfie.",
        "Leave a positive comment on a social media post of someone you don't know.",
        "Participate in a community event or volunteer opportunity to meet new people.",
        "Share a smile and a wave with someone across the street.",
        "Help someone who is struggling with directions or finding a location.",
        "Introduce yourself to a new coworker or classmate and express genuine interest.",
        "Start a conversation with a fellow commuter during public transportation.",
        "Share a book recommendation with someone at a bookstore or library.",
        "Take a moment to visualize your happy place and immerse yourself in the imagery.",
        "Text someone a virtual rainbow and sunshine emoji to brighten their day.",
        "Write down one thing that makes you feel proud to be you.",
        "Share a favorite motivational quote with a friend.",
        "Text someone a virtual bouquet of flowers emoji.",
        "Spend a few minutes imagining a successful and joyful future.",
        "Write a note of gratitude to yourself for the positive traits you possess.",
        "Text someone \"You inspire me\" with a heart emoji.",
        "Take a moment to appreciate the taste of your favorite fruit.",
        "Reflect on a time when someone's kindness made a difference in your day.",
        "Share a positive affirmation with someone who may need it.",
        "Text someone a virtual starry night sky emoji.",
        "Write down one thing that brings you a sense of peace.",
        "Choose a word that represents strength and focus on it today.",
        "Text someone \"You're a gem\" with a gemstone emoji.",
        "Spend a few minutes thinking about the people who bring joy to your life.",
        "Write a note to yourself about the beauty you see in the mirror.",
        "Text someone a virtual heartwarming hug emoji.",
        "Take a moment to appreciate the sound of laughter.",
        "Reflect on a time when you felt a strong sense of community.",
        "Share a fun fact with a friend to spark curiosity.",
        "Text someone a virtual cup of hot cocoa emoji.",
        "Write down one thing that makes you feel excited about the present.",
        "Choose a positive word and find ways to incorporate it into your day.",
        "Text someone \"You make the world a better place\" with a world emoji.",
        "Spend a few minutes appreciating the natural beauty around you.",
        "Write a note to yourself about a recent act of kindness you performed.",
        "Text someone a virtual celebration emoji.",
        "Take a moment to appreciate the feeling of warmth, whether from the sun or a cozy blanket.",
        "Reflect on a time when you felt genuine happiness and carry that feeling with you.",
        "Take a moment to appreciate the color of the sky.",
        "Text someone a virtual hug emoji.",
        "Write a list of things you love about your favorite season.",
        "Share a favorite childhood memory with a friend.",
        "Text someone a virtual rainbow emoji.",
        "Spend a few minutes looking at cute animal photos online.",
        "Write a note to yourself about a recent accomplishment.",
        "Text someone \"You're awesome\" with a smiley face.",
        "Take a moment to appreciate the taste of your favorite snack.",
        "Reflect on a skill or talent you have and feel proud of it.",
        "Share a positive affirmation with someone.",
        "Text someone a virtual beach emoji.",
        "Write down one thing you're excited about for the future.",
        "Choose a word of the day and find ways to embody it.",
        "Text someone a virtual heart-eyes emoji.",
        "Spend a few minutes appreciating the silence around you.",
        "Write a note of encouragement to yourself.",
        "Text someone a virtual ice cream cone emoji.",
        "Take a moment to appreciate the texture of different surfaces around you.",
        "Reflect on a time when you made someone smile.",
        "Share a motivational quote with a friend.",
        "Text someone a virtual peace sign emoji.",
        "Write down one thing you're looking forward to tomorrow.",
        "Take a moment to appreciate the sound of your surroundings.",
        "Text someone a virtual cupcake emoji.",
        "Write a list of simple joys that make you happy.",
        "Share a positive thought with someone.",
        "Text someone a virtual shooting star emoji.",
        "Take a moment to appreciate your favorite piece of clothing.",
        "Reflect on a moment when you felt truly content.",
        "Share a fun and lighthearted fact with a friend.",
        "Text someone a virtual dance emoji.",
        "Write down one thing you appreciate about your living space.",
        "Take a moment to appreciate the beauty of everyday objects.",
        "Text someone a virtual sunflower emoji.",
        "Spend a few minutes reminiscing about a happy event.",
        "Write a note to yourself about a small victory today.",
        "Text someone \"Thank you for being you\" with a heart emoji.",
        "Take a moment to appreciate the uniqueness of your fingerprints.",
        "Share a positive memory with a friend.",
        "Text someone a virtual hot air balloon emoji.",
        "Write down one thing that made you laugh today.",
        "Reflect on a time when you felt a sense of accomplishment.",
        "Text someone a virtual book emoji.",
        "Take a moment to appreciate the taste of a refreshing drink.",
        "Write a note to yourself about a positive change you've made.",
        "Text someone \"You make the world brighter\" with a sunshine emoji.",
        "Spend a few minutes observing the movement of clouds.",
        "Share a simple joy you experienced today with a friend.",
        "Text someone a virtual butterfly emoji.",
        "Take a moment to appreciate the beauty of a flower or plant.",
        "Text someone a fun fact or interesting trivia.",
        "Write down a small goal for the day and accomplish it.",
        "Share a funny meme with a friend.",
        "Choose a positive word for the day and focus on embodying it.",
        "Take a short walk around your living space.",
        "Write a list of your favorite quotes and revisit them.",
        "Text someone a virtual high-five emoji.",
        "Look through old photos and relive happy memories.",
        "Spend a few minutes daydreaming about something positive.",
        "Watch a short motivational TED Talk.",
        "Take a moment to feel the warmth of sunlight on your skin.",
        "Text a friend a compliment about something you admire in them.",
        "Write down one thing you're proud of accomplishing today.",
        "Browse through a collection of uplifting quotes.",
        "Take a break to enjoy a piece of fruit.",
        "Write a short thank-you note to someone who has supported you.",
        "Text someone a heartwarming emoji.",
        "Reflect on a favorite childhood game or activity and smile about it.",
        "Create a list of simple pleasures that bring you joy.",
        "Text a friend or family member a virtual flower emoji.",
        "Take a moment to be mindful of your surroundings.",
        "Write a note to yourself about something you look forward to.",
        "Share a positive news story with someone.",
        "Text someone a virtual cup of coffee emoji.",
        "Spend a few minutes listening to calming sounds or music.",
        "Write a list of things that make you unique and embrace them.",
        "Text someone \"Good luck\" if they have an upcoming event.",
        "Reflect on a favorite childhood snack and treat yourself to it.",
        "Text someone a virtual thumbs-up emoji.",
        "Take a moment to appreciate the texture of an object around you.",
        "Write down one thing you appreciate about each season.",
        "Text someone a virtual sunshine emoji.",
        "Take a moment to appreciate the sensation of touch, like the warmth of a blanket.",
        "Share a funny joke with a friend.",
        "Write a list of activities that bring you a sense of calm.",
        "Text someone a virtual balloon emoji.",
        "Take a moment to enjoy the smell of your favorite scented item.",
        "Reflect on a time when you overcame a challenge and felt proud.",
        "Text someone a virtual star emoji.",
        "Take a moment to stretch and take a few deep breaths.",
        "List three things that made you smile today.",
        "Text a friend or family member a positive message.",
        "Listen to your favorite uplifting song.",
        "Try a new type of tea and savor the flavor.",
        "Write down one thing you love about yourself.",
        "Watch a short, funny video to lighten your mood.",
        "Take a 5-minute break to enjoy a cup of coffee or tea.",
        "Choose a small area to declutter for just 10 minutes.",
        "Send a heart emoji to someone you appreciate.",
        "Look at photos that bring back happy memories.",
        "Write a sticky note with an encouraging message to yourself.",
        "Take a moment to look up at the sky and appreciate its vastness.",
        "Set a timer for 3 minutes and focus on your breath.",
        "Say \"thank you\" to someone who has helped you recently.",
        "Plan a simple dinner with your favorite comfort food.",
        "Text someone \"Good morning\" or \"Good night\" with a smiley face.",
        "Watch a short motivational video.",
        "Write a list of three things you're excited about for tomorrow.",
        "Choose a daily mantra, like \"I am capable and strong.\"",
        "Spend 5 minutes doing a quick and easy workout.",
        "Text someone a virtual hug emoji.",
        "Write a note of appreciation to someone you work or live with.",
        "Look in the mirror and give yourself a compliment.",
        "Set a goal to drink an extra glass of water today.",
        "Take a moment to enjoy a piece of chocolate or your favorite treat.",
        "Watch the sunset or sunrise for a few minutes.",
        "Text a friend a simple \"thinking of you\" message.",
        "Choose one thing to do today that brings you joy.",
        "Write a list of things you're grateful for right now.",
    ]
}
//======================================================================================================
extension Constants {
    static let breathingExercises: [String: [String]] = [
        "Equal Breathing (Sama Vritti):" :
            ["Inhale for a count of",
             "Hold the breath for a count of",
             "Exhale for a count of",
             "Repe"],
        
        "4-7-8 Breathing (Relaxing Breath):" :
            [
                "Inhale for a count of",
                "Hold the breath for a count of",
                "Exhale for a count of",
                "Repe",
            ],
        "Box Breathing (Square Breathing):" : [
            "Inhale for a count of",
            "Hold the breath for a count of",
            "Exhale for a count of",
            "Hold the breath for a count of",
            "Repe",
        ],
        
        "Alternate Nostril Breathing (Nadi Shodhana):" :
            [
                "Inhale through the left nostril for a count of",
                "Hold the breath for a count of",
                "Exhale through the right nostril for a count of",
                "Repeat, alternating nostri",
            ],
        "Bhramari Pranayama (Bee Breath):" : [
            "Inhale deeply",
            "Exhale with a humming sound like a bee for a count of"
        ],
        "Ujjayi Breath (Ocean Breath):" :
            ["Inhale slowly through the nose, filling the lungs.",
             "Exhale through the nose with a slight constriction, creating an ocean-like sound.",
             "Repeat.",
            ],
        
        "Kapalabhati (Skull-Shining Breath):" :
            [
                "Inhale naturally.",
                "Exhale forcefully through the nose, contracting the abdomen.",
                "Inhale passively.",
                "Repeat in quick, rhythmic bursts.",
            ],
        
        "Sitali Pranayama (Cooling Breath):" :
            [
                "Inhale through a rolled tongue or between the teeth for a count of.",
                "Hold the breath for a count of.",
                "Exhale through the nose for a count of.",
                "Repeat.",
            ],
        
        "Nadi Shuddhi (Alternate Nostril Cleansing):" :
            [
                "Inhale through the left nostril for a count of.",
                "Hold the breath for a count of.",
                "Exhale through the right nostril for a count of.",
                "Repeat, alternating nostrils.",
            ],
        "3-Part Breath (Dirga Pranayama):" :
            [
                "Inhale deeply into the lower abdomen for a count of.",
                "Continue inhaling, filling the chest for a count of.",
                "Complete the inhale, expanding the upper chest for a count of.",
                "Exhale slowly and completely.",
                "Repeat.",
            ],
        "Extended Exhale Breath:" :
            [
                "Inhale for a count of.",
                "Exhale for a count of.",
                "Repeat.",
            ],
        "4-4-8-4 Breath:" :
            [
                "Inhale for a count of 4.",
                "Hold the breath for a count of 4.",
                "Exhale for a count of 8.",
                "Hold the breath for a count of 4.",
                "Repeat.",
            ],
        "Sun-Moon Breath:" :
            [
                "Inhale through the right nostril for a count of 4.",
                "Switch and exhale through the left nostril for a count of 4.",
                "Inhale through the left nostril for a count of 4.",
                "Switch and exhale through the right nostril for a count of 4.",
                "Repeat.",
            ],
        "Breath of Fire (Kapalabhati variation):" :
            [
                "Rapidly exhale short breaths through the nose.",
                "Passive inhale.",
                "Repeat in a rhythmic manner.",
            ],
        "Counted Breath (Anulom Vilom):" :
            [
                "Inhale through one nostril for a count of 4.",
                "Hold the breath for a count of 4.",
                "Exhale through the opposite nostril for a count of 4.",
                "Repeat, alternating nostrils.",
            ],
        "Triangle Breath:" :
            [
                "Inhale for a count of 3.",
                "Hold the breath for a count of 3.",
                "Exhale for a count of 6.",
                "Repeat.",
            ],
        "Heart-Centered Breath:" :
            [
                "Inhale into the heart center, feeling love and warmth for a count of 4.",
                "Exhale from the heart center, releasing tension and negativity for a count of 6.",
                "Repeat.",
            ],
        "Sama Vritti with Ratio Increase:" :
            [
                "Inhale for a count of 4.",
                "Hold the breath for a count of 4.",
                "Exhale for a count of 6.",
                "Gradually increase the exhale count while keeping the inhale and hold consistent.",
            ],
        "Balancing Breath (Surya Bhedana):" :
            [
                "Inhale through the right nostril for a count of 4.",
                "Hold the breath for a count of 4.",
                "Exhale through the left nostril for a count of 4.",
                "Repeat, emphasizing the right nostril.",
            ],
        "Guided Visualization Breath:" :
            [
                "Inhale for a count of 4 while visualizing positive energy entering your body.",
                "Hold the breath for a count of 4, feeling the energy within.",
                "Exhale for a count of 4, releasing any tension or negativity.",
                "Repeat, focusing on a different visualization each cycle.",
            ],
        "Kumbhaka Pranayama (Breath Retention):" :
            [
                "Inhale deeply for a count of 8.",
                "Hold the breath (kumbhaka) for a count of 16.",
                "Exhale completely for a count of 8.",
                "Hold the breath out for a count of 8.",
                "Gradually increase the counts as you become more comfortable.",
            ],
        "Bhastrika Pranayama (Bellows Breath):" :
            [
                "Inhale and exhale rapidly through the nose.",
                "Focus on the forceful nature of the breath.",
                "Gradually increase the speed over time.",
                "Conclude with a slow, deep inhale and exhale.",
            ],
        "Nauli Kriya (Abdominal Churning):" :
            [
                "Stand with feet shoulder-width apart, hands on knees.",
                "Exhale completely, pulling the abdominal muscles inward.",
                "Perform rhythmic contractions and relaxations of the abdominal muscles.",
                "Practice under the guidance of an experienced teacher.",
            ],
        "Sitali Pranayama with Bandhas (Cooling Breath with Locks):" :
            [
                "Inhale through a rolled tongue or between the teeth for a count of 8.",
                "Perform Mula Bandha (root lock) and Uddiyana Bandha (abdominal lock).",
                "Hold the breath inside for a count of 8.",
                "Release the locks and exhale for a count of 8.",
            ],
        "Kapalabhati with Bandhas (Skull-Shining Breath with Locks):" :
            [
                "Perform rapid exhalations with forceful contractions of the abdomen.",
                "Simultaneously engage Mula Bandha and Uddiyana Bandha.",
                "After a series of rapid exhalations, inhale deeply and hold.",
                "Release the locks and exhale completely.",
            ],
        "Daily Extended Exhale Practice:" :
            [
                "Begin your day with a 5-minute extended exhale practice.",
                "Incorporate a 3-minute extended exhale session during a stressful moment.",
                "Wind down in the evening with a 7-minute extended exhale session.",
            ],
        "Focused Extended Exhale Breaks:" :
            [
                "Set reminders for three 2-minute focused extended exhale breaks throughout the day.",
                "Use a 4-minute extended exhale break during transitions between tasks.",
                "Practice a 6-minute extended exhale session before entering a meeting.",
            ],
        "Morning 4-4-8-4 Routine:" :
            [
                "Start your day with a 6-minute 4-4-8-4 breath routine.",
                "Incorporate a 4-minute session during a midday break for a mental reset.",
                "Conclude your evening with an 8-minute 4-4-8-4 breath routine.",
            ],
        "Stress Relief 4-4-8-4 Session:" :
            [
                "Practice a 5-minute 4-4-8-4 breath routine during a high-stress moment.",
                "Use a 7-minute 4-4-8-4 session to transition from work to personal time.",
                "Experiment with varying the exhale count for added challenge during a 10-minute session.",
            ],
        "Daily Sun-Moon Meditation:" :
            [
                "Start your day with a 5-minute sun-moon breath meditation.",
                "Practice a 3-minute session during a brief break for mental clarity.",
                "Wind down in the evening with a 7-minute sun-moon breath meditation.",
            ],
        "Sun-Moon Reflection:" :
            [
                "Reflect on the balancing aspects of the sun-moon breath after a session for 4 minutes.",
                "Share your experience with a friend or family member for 6 minutes.",
                "Experiment with extending the duration of each phase during a 9-minute session.",
                "Breath of Fire (Kapalabhati variation):",
            ],
        "Energizing Breath of Fire:" :
            [
                "Include a 5-minute breath of fire session in your morning routine.",
                "Use a 3-minute breath of fire session as a midday pick-me-up.",
                "Conclude your day with a 7-minute breath of fire session for vitality.",
            ],
        "Focused Breath of Fire Breaks:" :
            [
                "Set reminders for three 2-minute focused breath of fire breaks throughout the day.",
                "Incorporate a 4-minute breath of fire session during transitions between tasks.",
                "Experiment with varying the pace of breath of fire for intensity during a 6-minute session.",
                "Counted Breath (Anulom Vilom):",
            ],
        "Morning Counted Breath Practice:" :
            [
                "Begin your day with a 6-minute counted breath session.",
                "Practice a 4-minute session during a midday break for focus.",
                "Conclude your evening with an 8-minute counted breath session.",
            ],
        "Stress Relief Counted Breath:" : [
            "Use a 5-minute counted breath session during a high-stress moment.",
            "Incorporate a 7-minute session to transition from work to personal time.",
            "Experiment with gradually increasing the count during a 10-minute session.",
        ]
    ]
}

extension Constants {
    static let mindfullnessExercise: [String: String] = [
        "Guided Meditation" :
            "Use guided meditation recordings or app with calming voices to lead you through a meditation session.",
        
        "Visualization" :
            "Picture a peaceful scene, such as a serene beach or a tranquil forest, in your mind. Immerse yourself in the details to enhance relaxation.",
        
        "Body Scan Meditation":
            "Bring awareness to different parts of your body, starting from your toes and moving up to your head. Notice any sensations without judgment.",
        
        "Mindfulness Meditation":
            "Focus on the present moment without judgment. Observe your thoughts and feelings without getting attached to them.",
        
        "Mantra Meditation":
            "Repeat a mantra silently or aloud. This could be a word, phrase, or sound that holds personal significance or promotes a sense of calm.",
        
        "Walking Meditation":
            "Practice meditation while walking slowly and mindfully. Pay attention to each step and your surroundings.",
        
        "Loving-Kindness Meditation (Metta)":
            "Cultivate feelings of love and compassion. Extend well-wishes to yourself and others, gradually expanding the circle of compassion.",
        
        "Mindful Eating":
            "Eat a small piece of food slowly, paying full attention to the taste, texture, and sensations. This can be a form of moving meditation.",
        
        "Candle Gazing (Trataka)":
            "Focus your gaze on the flame of a candle. Keep your attention on the flame and let other thoughts fade away.",
        
        "Sound Meditation":
            "Listen to calming sounds, such as singing bowls, nature sounds, or specially designed meditation music.",
        
        "Aromatherapy":
            "Use essential oils or incense with calming scents like lavender or chamomile to create a serene environment.",
        
        "Yoga Nidra":
            "Also known as \"yogic sleep,\" this practice involves deep relaxation while maintaining awareness. It's often guided and can lead to a state between wakefulness and sleep.",
        
        "Body Movement Meditation":
            "Engage in gentle movements like tai chi or qigong, focusing on the sensations and mindfulness in each movement.",
        
        "Journaling":
            "Reflect on your thoughts, feelings, and experiences before or after meditation. This can help clarify your thoughts and promote self-awareness.",
        
        "Nature Meditation":
            "Sit or walk in nature and immerse yourself in the sights, sounds, and smells. Connect with the natural world to enhance mindfulness.",
    ]
    
    static let multyFunctionMindfullnessExercises: [String: [String]] =
    [
        "Use a Guided Meditation App":
            [
                "Start your day with a 10-minute guided meditation session.",
                "Incorporate a 5-minute guided meditation during a lunch break.",
                "Choose a longer guided meditation (15-20 minutes) for an evening session.",
                "Explore Different Guided Meditations:",
                "Try a new guided meditation theme in the morning for 8 minutes.",
                "Explore a meditation for better sleep in the afternoon for 12 minutes.",
                "End your day with a gratitude-focused guided meditation for 15 minutes.",
            ],
        
        "Create Your Own Guided Session":
            [
                "Record a 5-minute guided meditation for morning focus.",
                "Listen to your recording during a stress-prone moment for 3 minutes.",
                "Share your guided meditation with a friend or family member.",
            ],
        
        "Imagine a Calming Place":
            [
                "Dedicate 10 minutes to mentally explore your serene place in the morning.",
                "Visualize your calming place during a stressful moment for 5 minutes.",
                "Use a 7-minute visualization before bedtime for relaxation.",
            ],
        
        "Visualize Achieving a Goal":
            [
                "Spend 5 minutes visualizing achieving a specific goal during the day.",
                "Reflect on your visualized goal during a break for 3 minutes.",
                "Create a vision board in the evening for 15 minutes.",
            ],
        
        "Create a Vision Board":
            [
                "Spend 10 minutes collecting images for your vision board in the morning.",
                "Arrange and create your vision board during a creative break for 20 minutes.",
                "Reflect on your vision board in the afternoon for 5 minutes.",
            ],
        
        "Mindful Morning Routine":
            [
                "Practice mindfulness during your morning routine for 5 minutes.",
                "Extend mindfulness to a specific activity (e.g., shower) for 7 minutes.",
                "Bring mindfulness to breakfast for 8 minutes.",
            ],
        
        "Mindful Breathing Breaks":
            [
                "Set reminders for three 2-minute mindful breathing breaks throughout the day.",
                "Pause and practice mindful breathing during a challenging task for 3 minutes.",
                "Use a 5-minute mindful breathing break before transitioning to a new activity.",
            ],
        
        "Body Scan Meditation":
            [
                "Dedicate 15 minutes to a body scan meditation in the evening.",
                "Practice a 10-minute body scan during a break to release tension.",
                "Use a quick 5-minute body scan to center yourself before a meeting.",
            ],
        
        "Morning Mantra Ritual":
            [
                "Repeat your morning mantra silently for 5 minutes.",
                "Reflect on your morning mantra during a midday break for 3 minutes.",
                "Incorporate your mantra into a brief mindfulness session before bedtime for 7 minutes.",
            ],
        "Mantra Journaling":
            [
                "Journal about your chosen mantra's significance for 10 minutes.",
                "Reflect on how your mantra applies to the day during a break for 5 minutes.",
                "Explore variations of your mantra in a journaling session lasting 12 minutes.",
            ],
        
        "Silent Mantra Meditation":
            [
                "Practice silent mantra meditation for 8 minutes in the morning.",
                "Use a 6-minute silent mantra meditation during a reflective moment in the afternoon.",
                "Conclude your day with a 10-minute silent mantra meditation.",
            ],
        
        "Candle Focus Warm-up":
            [
                "Begin your day with 3 minutes of gentle candle gazing.",
                "Incorporate a 5-minute candle gazing session during a work break.",
                "Conclude your evening with a 7-minute candle focus before bedtime.",
            ],
        
        "Candle Gazing Reflection":
            [
                "After a candle gazing session, journal about your experience for 5 minutes.",
                "Share your candle gazing reflections with a friend or family member for 8 minutes.",
                "Experiment with focusing on different aspects of the flame for 6 minutes.",
            ],
        
        "Nature Sounds Session":
            [
                "Find a quiet outdoor spot and immerse yourself in nature sounds for 10 minutes.",
                "Create a playlist of calming sounds and listen during a relaxation break for 7 minutes.",
                "Experiment with focusing on specific sounds in your environment for 5 minutes.",
            ],
        
        "Sound Exploration":
            [
                "Attend a live music performance or listen to a recorded one for 15 minutes.",
                "Explore different meditation music genres during a mindfulness session for 12 minutes.",
                "Incorporate singing bowls or chimes into your meditation routine for 8 minutes.",
            ],
        
        "Daily Sound Diary":
            [
                "Keep a daily sound diary, noting the sounds that bring joy or calmness for 5 minutes.",
                "Reflect on how certain sounds impact your mood during a break for 6 minutes.",
                "Share your favorite calming sounds with someone for 3 minutes.",
            ],
        
        "Mindful Aroma Moments":
            [
                "Engage in a brief aromatherapy session with calming scents for 5 minutes.",
                "Carry a small scented item and use it as a focus point during a mindful break for 4 minutes.",
                "Explore different essential oils and their effects on your mood for 7 minutes.",
            ],
        "Scented Meditation Space":
            [
                "Create a scented meditation space with candles or diffusers for 10 minutes.",
                "Incorporate aromatherapy into your bedtime routine for a peaceful night's sleep (8 minutes).",
                "Use scents associated with positive memories in your meditation practice for 6 minutes.",
            ],
        
        "Scented Journaling":
            [
                "Journal about the emotional impact of a specific scent for 5 minutes.",
                "Share your favorite scents with a friend and discuss their effects for 7 minutes.",
                "Experiment with combining different scents for a personalized aroma experience (9 minutes).",
            ],
        
        "Nightly Yoga Nidra Practice":
            [
                "Dedicate 15 minutes to Yoga Nidra before bedtime.",
                "Practice a shorter Yoga Nidra session during a midday break for 10 minutes.",
                "Explore guided Yoga Nidra recordings with varying themes for 20 minutes.",
            ],
        
        "Yoga Nidra Reflection":
            [
                "Journal about your experiences during and after a Yoga Nidra session for 8 minutes.",
                "Share your Yoga Nidra reflections with a meditation buddy for 12 minutes.",
                "Experiment with creating your own personalized Yoga Nidra script for 15 minutes.",
            ],
        
        "Yoga Nidra Body Exploration":
            [
                "Focus on specific body sensations during a Yoga Nidra session for 7 minutes.",
                "Incorporate progressive muscle relaxation into your Yoga Nidra practice for 9 minutes.",
                "Reflect on the impact of body-focused Yoga Nidra on your overall well-being for 11 minutes.",
            ],
        
        "Qi Gong Flow":
            [
                "Dedicate 15 minutes to a Qi Gong flow in the morning.",
                "Integrate a short Qi Gong movement break during work for 8 minutes.",
                "Wind down with a 10-minute evening Qi Gong session.",
            ],
        
        "Tai Chi Mindful Movements":
            [
                "Practice Tai Chi movements with focused breath for 12 minutes.",
                "Incorporate Tai Chi into your outdoor routine for 15 minutes.",
                "Attend a Tai Chi class or follow an online tutorial for 20 minutes.",
            ],
        
        "Dance Meditation":
            [
                "Dance freely to uplifting music for 10 minutes.",
                "Explore dance as a form of meditation, focusing on each movement for 8 minutes.",
                "Join a dance meditation class or group for a shared experience lasting 15 minutes.",
            ],
        
        "Full-Body Stretch":
            [
                "Begin your day with a 5-minute full-body stretching routine.",
                "Focus on major muscle groups, holding each stretch for 15-30 seconds.",
                "Incorporate gentle neck and shoulder stretches to release tension.",
            ],
        
        "Dynamic Morning Movements":
            [
                "Include dynamic movements like arm circles, leg swings, and torso twists.",
                "Perform these movements for 3 minutes to wake up your body.",
                "Combine stretches with controlled breathing for added mindfulness.",
            ],
        
        "Sun Salutations (Surya Namaskar)":
            [
                "Practice 3 rounds of sun salutations for a total-body workout.",
                "Focus on the flow of movements, synchronizing breath with each posture.",
                "Gradually increase the number of rounds as your stamina improves.",
            ],
        
        "Stair Climbing Breaks":
            [
                "Take short breaks during the afternoon to climb stairs.",
                "Aim for 5 minutes of stair climbing to boost circulation and energy.",
                "Experiment with varying your pace for added intensity.",
            ],
        
        "Desk Exercises":
            [
                "Integrate desk exercises like seated leg lifts and chair squats.",
                "Perform these exercises for 4 minutes during work breaks.",
                "Include seated stretches to relieve tension in the neck and shoulders.",
            ],
    ]
}
