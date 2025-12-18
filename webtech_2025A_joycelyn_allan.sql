-- phpMyAdmin SQL Dump
-- version 5.2.1deb3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 17, 2025 at 07:24 PM
-- Server version: 8.0.44-0ubuntu0.24.04.2
-- PHP Version: 8.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `webtech_2025A_joycelyn_allan`
--

-- --------------------------------------------------------

--
-- Table structure for table `age_hair_factors`
--

CREATE TABLE `age_hair_factors` (
  `factor_id` int NOT NULL,
  `age_group` enum('child','teen','young_adult','adult','middle_aged','senior') COLLATE utf8mb4_general_ci NOT NULL,
  `factor_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `impact_level` enum('low','medium','high','critical') COLLATE utf8mb4_general_ci DEFAULT 'medium',
  `recommendations` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `age_hair_factors`
--

INSERT INTO `age_hair_factors` (`factor_id`, `age_group`, `factor_name`, `description`, `impact_level`, `recommendations`) VALUES
(1, 'child', 'Developing Hair Follicles', 'Hair follicles are still maturing, texture and density may change', 'high', 'Use extremely gentle products, avoid chemicals completely, focus on scalp health and gentle detangling'),
(2, 'child', 'Sensitive Scalp', 'Children have more sensitive scalps requiring gentler care', 'high', 'Use tear-free, fragrance-free products. Avoid adult products with harsh chemicals'),
(3, 'child', 'Natural Hair Changes', 'Hair texture naturally evolves through childhood', 'medium', 'Allow natural development, avoid heat styling, protective styles should be very loose'),
(4, 'teen', 'Hormonal Changes', 'Puberty hormones significantly affect hair texture and growth', 'critical', 'Expect texture changes, increased oiliness or dryness. Establish healthy hair care habits early'),
(5, 'teen', 'Styling Pressure', 'Social pressure for heat styling and chemical treatments', 'high', 'Educate on heat damage risks, promote heat-free styling, limit chemical treatments'),
(6, 'teen', 'Scalp Oil Production', 'Increased sebum production during puberty', 'medium', 'May need more frequent washing, use clarifying treatments monthly, balance moisture'),
(7, 'young_adult', 'Peak Hair Health', 'Hair typically at its healthiest and strongest', 'low', 'Focus on prevention and maintenance, establish long-term healthy habits'),
(8, 'young_adult', 'Styling Experimentation', 'Period of trying different styles and treatments', 'medium', 'Balance experimentation with protective practices, monitor cumulative damage'),
(9, 'young_adult', 'Postpartum Changes', 'Pregnancy and postpartum can cause temporary shedding', 'high', 'Postpartum shedding is normal 3-6 months after birth. Focus on nutrition and gentle care'),
(10, 'adult', 'Early Hormonal Shifts', 'Beginning of hormonal changes affecting hair', 'medium', 'Increase protein and moisture treatments, monitor for texture changes'),
(11, 'adult', 'Stress Impact', 'Career and family stress affects hair health', 'high', 'Stress management crucial, consider scalp massages, adequate sleep and nutrition'),
(12, 'adult', 'Gray Hair Emergence', 'Gray hairs begin appearing, different care needs', 'medium', 'Gray hair is coarser and drier, needs extra moisture and gentle handling'),
(13, 'middle_aged', 'Menopause/Andropause', 'Major hormonal changes drastically affect hair', 'critical', 'Hormonal therapy consultation, focus on scalp health, increase moisture treatments'),
(14, 'middle_aged', 'Decreased Hair Density', 'Natural thinning and slower growth', 'high', 'Gentle handling, avoid tight styles, scalp stimulation, consider growth supplements'),
(15, 'middle_aged', 'Texture Coarsening', 'Hair becomes coarser and drier', 'high', 'Deep conditioning 2x weekly, heavier moisturizers, avoid harsh chemicals'),
(16, 'middle_aged', 'Slower Growth Cycle', 'Hair growth slows significantly', 'high', 'Realistic expectations, focus on retention over growth, gentle protective styling'),
(17, 'senior', 'Fragile Hair Structure', 'Hair becomes significantly more fragile', 'critical', 'Extremely gentle handling, avoid tension, minimal manipulation, silk pillowcases essential'),
(18, 'senior', 'Scalp Sensitivity', 'Scalp becomes thinner and more sensitive', 'high', 'Gentle scalp care, avoid harsh scrubbing, moisturize scalp regularly'),
(19, 'senior', 'Medication Effects', 'Many medications affect hair health', 'high', 'Consult doctors about medication side effects, adjust care accordingly'),
(20, 'senior', 'Reduced Sebum', 'Less natural oil production', 'high', 'Increase oil treatments, less frequent washing, focus on moisture retention');

-- --------------------------------------------------------

--
-- Table structure for table `age_specific_concerns`
--

CREATE TABLE `age_specific_concerns` (
  `age_concern_id` int NOT NULL,
  `age_group` enum('child','teen','young_adult','adult','middle_aged','senior') COLLATE utf8mb4_general_ci NOT NULL,
  `concern_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `prevalence` enum('rare','occasional','common','very_common') COLLATE utf8mb4_general_ci DEFAULT 'common',
  `typical_causes` text COLLATE utf8mb4_general_ci,
  `recommended_actions` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `age_specific_concerns`
--

INSERT INTO `age_specific_concerns` (`age_concern_id`, `age_group`, `concern_name`, `description`, `prevalence`, `typical_causes`, `recommended_actions`) VALUES
(1, 'child', 'Cradle Cap', 'Seborrheic dermatitis in infants and young children', 'common', 'Immature oil glands, buildup', 'Gentle brushing, baby shampoo, consult pediatrician if severe'),
(2, 'child', 'Tangles and Knots', 'Difficulty managing tangled hair', 'very_common', 'Active play, sensitive scalp, improper detangling', 'Detangle spray, wide-tooth comb, patience, make it fun'),
(3, 'child', 'Head Lice', 'Common parasitic infestation in schools', 'common', 'Close contact with infected children', 'Immediate treatment, notify school, prevent sharing items'),
(4, 'teen', 'Excessive Oiliness', 'Overactive sebaceous glands', 'very_common', 'Hormonal changes during puberty', 'More frequent washing, clarifying treatments, oil-free products'),
(5, 'teen', 'Heat Damage', 'Damage from styling tools', 'common', 'Learning to style, peer pressure, lack of knowledge', 'Education on heat protection, promote heat-free styles'),
(6, 'teen', 'Acne on Scalp', 'Scalp breakouts related to hormones', 'common', 'Hormonal fluctuations, product buildup', 'Gentle cleansing, avoid pore-clogging products'),
(7, 'young_adult', 'Postpartum Shedding', 'Excessive shedding after childbirth', 'common', 'Hormonal shifts after pregnancy', 'Temporary condition, gentle care, proper nutrition, patience'),
(8, 'young_adult', 'Chemical Damage', 'Damage from color, relaxers, perms', 'common', 'Experimentation, frequent changes', 'Protein treatments, deep conditioning, professional services'),
(9, 'middle_aged', 'Menopausal Hair Loss', 'Thinning related to menopause', 'very_common', 'Declining estrogen levels', 'Consult doctor, minoxidil, supplements, gentle handling'),
(10, 'middle_aged', 'Increased Gray Hair', 'Rapid graying and texture change', 'very_common', 'Natural aging process', 'Extra moisture, gentle handling, embrace or color safely'),
(11, 'middle_aged', 'Frontal Fibrosing Alopecia', 'Hairline recession in women', 'occasional', 'Inflammatory condition, hormones', 'Medical evaluation immediately, dermatologist consultation'),
(12, 'senior', 'Androgenetic Alopecia', 'Pattern baldness in older adults', 'very_common', 'Genetics, hormones, aging', 'Medical treatments, gentle styling, realistic expectations'),
(13, 'senior', 'Brittle Hair Syndrome', 'Extreme fragility and breakage', 'common', 'Age-related structural changes', 'Extreme gentleness, moisture focus, minimal manipulation'),
(14, 'senior', 'Scalp Psoriasis', 'Inflammatory skin condition', 'occasional', 'Immune system, genetics', 'Dermatologist care, medicated treatments, gentle products');

-- --------------------------------------------------------

--
-- Table structure for table `content_age_appropriateness`
--

CREATE TABLE `content_age_appropriateness` (
  `content_age_id` int NOT NULL,
  `content_id` int NOT NULL,
  `age_group` enum('child','teen','young_adult','adult','middle_aged','senior') COLLATE utf8mb4_general_ci NOT NULL,
  `is_appropriate` tinyint(1) DEFAULT '1',
  `age_specific_notes` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `content_age_appropriateness`
--

INSERT INTO `content_age_appropriateness` (`content_age_id`, `content_id`, `age_group`, `is_appropriate`, `age_specific_notes`) VALUES
(1, 1, 'child', 1, 'Adult supervision recommended for application. Use gentler techniques.'),
(2, 5, 'child', 1, 'Adult supervision recommended for application. Use gentler techniques.'),
(3, 2, 'child', 1, 'Adult supervision recommended for application. Use gentler techniques.'),
(4, 4, 'child', 1, 'Adult supervision recommended for application. Use gentler techniques.'),
(5, 10, 'child', 1, 'Adult supervision recommended for application. Use gentler techniques.'),
(6, 12, 'child', 1, 'Adult supervision recommended for application. Use gentler techniques.'),
(7, 3, 'child', 1, 'Adult supervision recommended for application. Use gentler techniques.'),
(8, 9, 'child', 1, 'Adult supervision recommended for application. Use gentler techniques.'),
(16, 1, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(17, 5, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(18, 6, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(19, 8, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(20, 11, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(21, 14, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(22, 17, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(23, 20, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(24, 2, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(25, 4, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(26, 10, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(27, 12, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(28, 13, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(29, 16, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(30, 18, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(31, 3, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(32, 7, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(33, 9, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(34, 15, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(35, 19, 'teen', 1, 'Great age to establish healthy habits. Avoid over-manipulation.'),
(47, 5, 'senior', 1, 'Use extra gentle techniques. Increase frequency of moisture treatments.'),
(48, 6, 'senior', 1, 'Use extra gentle techniques. Increase frequency of moisture treatments.'),
(49, 8, 'senior', 1, 'Use extra gentle techniques. Increase frequency of moisture treatments.'),
(50, 11, 'senior', 1, 'Use extra gentle techniques. Increase frequency of moisture treatments.'),
(51, 9, 'senior', 1, 'Use extra gentle techniques. Increase frequency of moisture treatments.'),
(54, 20, 'child', 0, 'Heat training not recommended for developing hair. Can cause permanent damage.');

-- --------------------------------------------------------

--
-- Table structure for table `content_hair_type_relevance`
--

CREATE TABLE `content_hair_type_relevance` (
  `relevance_id` int NOT NULL,
  `content_id` int NOT NULL,
  `hair_type_id` int NOT NULL,
  `relevance_score` int DEFAULT NULL
) ;

--
-- Dumping data for table `content_hair_type_relevance`
--

INSERT INTO `content_hair_type_relevance` (`relevance_id`, `content_id`, `hair_type_id`, `relevance_score`) VALUES
(1, 1, 1, 8),
(2, 1, 7, 10),
(3, 1, 10, 10),
(4, 1, 12, 10),
(5, 2, 7, 9),
(6, 2, 8, 9),
(7, 2, 9, 10),
(8, 2, 10, 10),
(9, 2, 11, 10),
(10, 2, 12, 10),
(11, 3, 1, 8),
(12, 3, 7, 10),
(13, 3, 10, 10),
(14, 3, 12, 10),
(15, 4, 1, 7),
(16, 4, 7, 9),
(17, 4, 10, 10),
(18, 4, 12, 10),
(19, 6, 7, 8),
(20, 6, 8, 9),
(21, 6, 9, 10),
(22, 6, 10, 10),
(23, 6, 11, 10),
(24, 6, 12, 10);

-- --------------------------------------------------------

--
-- Table structure for table `diagnosis_causes`
--

CREATE TABLE `diagnosis_causes` (
  `cause_id` int NOT NULL,
  `cause_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `category` enum('product','practice','nutrition','medical','environmental','hormonal','genetic','stress','other') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `prevention_tips` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `diagnosis_causes`
--

INSERT INTO `diagnosis_causes` (`cause_id`, `cause_name`, `category`, `description`, `prevention_tips`) VALUES
(1, 'Protein Overload', 'product', 'Excessive use of protein-based products leading to stiff, brittle hair that breaks easily.', 'Balance protein treatments with moisturizing deep conditioners. Use protein treatments only once a month for low porosity hair, twice a month for high porosity.'),
(2, 'Heat Damage', 'practice', 'Damage from frequent use of heat styling tools without proper protection, causing weakened hair structure.', 'Always use heat protectant spray before styling. Keep heat tools below 400┬░F. Air dry whenever possible and limit heat styling to once per week.'),
(3, 'Moisture Deficiency', 'practice', 'Insufficient hydration leading to dry, brittle hair prone to breakage.', 'Deep condition weekly, seal moisture with oils, drink plenty of water, and use leave-in conditioners daily.'),
(4, 'Iron Deficiency', 'nutrition', 'Low iron levels affecting hair growth and causing excessive shedding.', 'Consume iron-rich foods like spinach, red meat, and legumes. Consider iron supplements after consulting with a doctor.'),
(5, 'Vitamin D Deficiency', 'nutrition', 'Insufficient vitamin D impacting hair follicle health and growth cycle.', 'Get 15-20 minutes of sunlight daily, consume vitamin D-rich foods, or take supplements as recommended.'),
(6, 'Chemical Damage', 'practice', 'Damage from relaxers, perms, or bleaching that compromises hair structure.', 'Space chemical treatments at least 12 weeks apart. Always use professional services. Follow up with intensive treatments.'),
(7, 'Traction Alopecia', 'practice', 'Hair loss from consistently wearing tight braids, ponytails, or buns.', 'Avoid tight styles, give hair breaks between protective styles, vary your hairstyles.'),
(8, 'Product Build-up', 'product', 'Accumulation of styling products, oils, and conditioners blocking scalp pores.', 'Use clarifying shampoo monthly, avoid heavy products near scalp, ensure thorough rinsing.'),
(9, 'Hormonal Imbalance', 'hormonal', 'Conditions like PCOS, thyroid disorders, or menopause affecting hair growth.', 'Consult with endocrinologist, maintain healthy lifestyle, manage stress.'),
(10, 'Chronic Stress', 'stress', 'Prolonged stress causing telogen effluvium and disrupting normal hair growth cycle.', 'Practice stress management techniques like meditation, exercise regularly, ensure adequate sleep.'),
(11, 'Poor Scalp Health', 'practice', 'Neglected scalp care leading to clogged follicles, inflammation, or infection.', 'Massage scalp regularly, exfoliate monthly, keep scalp clean but not over-washed.'),
(12, 'Over-Manipulation', 'practice', 'Over-styling, combing, or touching hair causing mechanical damage and breakage.', 'Adopt low manipulation styles, use wide-tooth combs, detangle gently when wet with conditioner.'),
(13, 'Hard Water', 'environmental', 'Mineral deposits from hard water causing dryness, dullness, and product buildup.', 'Install water softener or shower filter, use chelating shampoo monthly.'),
(14, 'Sulfate Damage', 'product', 'Harsh sulfates in shampoos stripping natural oils and causing dryness.', 'Switch to sulfate-free shampoos, use gentler cleansing methods like co-washing.'),
(15, 'Low Protein Intake', 'nutrition', 'Insufficient dietary protein affecting keratin production and hair strength.', 'Consume adequate protein from eggs, fish, poultry, legumes, and nuts.'),
(16, 'Heat Damage', 'practice', 'Excessive use of heat styling tools without protection', 'Always use heat protectant, limit heat styling to 1-2 times per week, use lowest effective temperature'),
(17, 'Over-Manipulation', 'practice', 'Excessive touching, combing, or styling of hair', 'Protective styles, gentle detangling, minimize daily styling, sleep on silk pillowcase'),
(18, 'Protein-Moisture Imbalance', 'product', 'Too much protein or moisture causing brittleness or mushiness', 'Balance protein and moisture treatments, assess hair needs regularly, adjust products accordingly'),
(19, 'Harsh Sulfates', 'product', 'Sulfate-containing shampoos stripping natural oils', 'Switch to sulfate-free shampoos, co-washing, gentle cleansers'),
(20, 'Chemical Damage', 'practice', 'Damage from relaxers, perms, or color treatments', 'Limit chemical treatments, protein treatments, deep conditioning, professional application'),
(21, 'Poor Diet', 'nutrition', 'Insufficient vitamins and minerals for hair health', 'Eat protein-rich foods, take biotin supplement, stay hydrated, consume omega-3 fatty acids'),
(22, 'Hormonal Imbalance', 'hormonal', 'Hormones affecting hair growth cycle', 'Consult healthcare provider, manage stress, balanced diet, regular exercise'),
(23, 'Tight Hairstyles', 'practice', 'Traction from tight ponytails, braids, or buns', 'Loose styles, vary hairstyles, avoid tension on hairline, regular breaks from protective styles'),
(24, 'Product Buildup', 'product', 'Accumulation of products on hair and scalp', 'Clarifying shampoo monthly, thorough rinsing, avoid heavy products, regular scalp cleansing'),
(25, 'Low Porosity', 'genetic', 'Hair cuticles resist moisture absorption', 'Use heat with deep conditioning, lighter products, steam treatments, avoid heavy oils'),
(26, 'High Porosity', 'genetic', 'Hair cuticles too open, losing moisture quickly', 'Protein treatments, heavier sealants, cool water rinses, acidic products'),
(27, 'Vitamin Deficiency', 'nutrition', 'Lack of essential vitamins for hair growth', 'Multivitamin supplement, iron-rich foods, vitamin D, B-complex vitamins'),
(28, 'Stress', 'stress', 'Physical or emotional stress affecting hair cycle', 'Stress management techniques, adequate sleep, exercise, meditation, therapy'),
(29, 'Fungal Infection', 'medical', 'Scalp infection causing irritation and flaking', 'Antifungal treatments, keep scalp clean and dry, avoid sharing hair tools, see dermatologist'),
(30, 'Thyroid Issues', 'medical', 'Thyroid imbalance affecting hair growth', 'Medical evaluation, hormone therapy if needed, nutritional support'),
(31, 'Dry Climate', 'environmental', 'Low humidity causing moisture loss', 'Humidifier, moisturizing products, protective styling, cover hair in harsh weather'),
(32, 'Hard Water', 'environmental', 'Mineral buildup from hard water', 'Chelating shampoo, water filter, clarifying treatments, apple cider vinegar rinse'),
(33, 'Chlorine Exposure', 'environmental', 'Swimming pool chemicals damaging hair', 'Wet hair before swimming, wear swim cap, rinse immediately after, clarifying shampoo');

-- --------------------------------------------------------

--
-- Table structure for table `educational_content`
--

CREATE TABLE `educational_content` (
  `content_id` int NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `content_type` enum('article','video','infographic','tutorial','tip','guide','quiz') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `category` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `content_text` text COLLATE utf8mb4_general_ci,
  `content_url` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `thumbnail_url` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `author` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `published_at` date DEFAULT NULL,
  `views` int DEFAULT '0',
  `is_offline_available` tinyint(1) DEFAULT '0',
  `reading_time_minutes` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `educational_content`
--

INSERT INTO `educational_content` (`content_id`, `title`, `content_type`, `category`, `content_text`, `content_url`, `thumbnail_url`, `author`, `published_at`, `views`, `is_offline_available`, `reading_time_minutes`, `created_at`) VALUES
(1, 'Understanding Hair Porosity', 'article', 'Hair Science', 'Hair porosity refers to your hair\'s ability to absorb and retain moisture. It\'s determined by the condition of your cuticle layer. Low porosity hair has tightly closed cuticles, making it resistant to moisture absorption. High porosity hair has gaps in the cuticle, causing it to absorb water quickly but lose it just as fast. Medium porosity hair strikes the perfect balance. To test: place a clean strand in water. Floats = low porosity, sinks quickly = high porosity, slowly sinks = medium porosity. This knowledge is crucial for selecting the right products and techniques for your hair.', 'https://www.naturallycurly.com/curlreading/wavy-hair-type-2/the-411-on-hair-porosity', 'https://www.naturallycurly.com/wp-content/uploads/2019/01/hair-porosity-test.jpg', 'Dr. Amara Chen', '2025-01-15', 0, 1, 8, '2025-12-12 16:04:09'),
(2, 'The LOC Method Explained', 'tutorial', 'Hair Care Techniques', 'The LOC method is a game-changing moisture retention technique. LOC stands for Liquid, Oil, Cream - the order you layer products. Start with a water-based leave-in conditioner on damp hair. Next, apply a natural oil like jojoba or coconut to seal the moisture in. Finally, apply a cream-based moisturizer to lock everything in place. This method is especially effective for type 4 hair and high porosity hair that struggles with moisture retention. Apply immediately after washing while hair is still damp for maximum effectiveness. You can modify to LCO if your hair prefers cream before oil.', 'https://www.youtube.com/watch?v=fm8J8gorzkM', 'https://img.youtube.com/vi/fm8J8gorzkM/maxresdefault.jpg', 'Tiana Williams', '2025-02-01', 0, 1, 5, '2025-12-12 16:04:09'),
(3, 'Protective Styling Basics', 'guide', 'Styling', 'Protective styles are hairstyles that tuck away your ends and minimize daily manipulation, helping you retain length and reduce breakage. Popular options include braids, twists, wigs, buns, and updos. The key benefits are length retention, reduced breakage, and time savings. For success: never install too tightly (should be comfortable), moisturize your hair before installing, maintain your scalp while styled, and don\'t keep styles in too long (4-8 weeks maximum). Always take breaks between protective styles to let your hair and scalp breathe and recover. This is essential for maintaining healthy hair while growing it long.', 'https://www.byrdie.com/protective-hairstyles-5189649', 'https://www.byrdie.com/thmb/protective-styles.jpg', 'Kenya Roberts', '2025-01-20', 0, 1, 10, '2025-12-12 16:04:09'),
(4, 'Detangling Without Damage', 'tutorial', 'Hair Care Techniques', 'Proper detangling is crucial for preventing breakage and retaining length. Never detangle dry hair - always work with damp, conditioner-coated hair when it has maximum slip. Start from your ends and gradually work your way up to the roots, never forcing through tangles. Use a wide-tooth comb or your fingers. Section your hair into 4-6 manageable parts. Be patient and gentle throughout the process. For severe tangles, apply a detangling spray or oil. The best time to detangle is during your wash routine when your hair is saturated with conditioner. Remember: this process should never cause pain.', 'https://www.youtube.com/watch?v=DmCpaFB1_4Q', 'https://img.youtube.com/vi/DmCpaFB1_4Q/maxresdefault.jpg', 'Jasmine Foster', '2025-01-10', 0, 1, 6, '2025-12-12 16:04:09'),
(5, 'Deep Conditioning Mastery', 'article', 'Hair Care Techniques', 'Deep conditioning treatments penetrate the hair shaft to deliver intensive moisture and nutrients that regular conditioners can\'t. Apply deep conditioner to clean, damp hair, focusing extra product on your ends where hair is oldest. Cover with a plastic cap and apply heat for 20-30 minutes to open the cuticles - this is essential for low porosity hair. For high porosity hair, heat is optional but beneficial. Deep condition at least once weekly, more if your hair is damaged or very dry. Alternate between protein-based and moisture-based treatments. Signs you need moisture: dry, brittle, dull hair. Signs you need protein: stretchy, mushy, limp hair.', 'https://www.healthline.com/health/deep-conditioning-natural-hair', 'https://www.healthline.com/hlcmsresource/images/deep-conditioning.jpg', 'Dr. Amara Chen', '2025-02-05', 0, 1, 7, '2025-12-12 16:04:09'),
(6, 'Hair Growth Cycle Science', 'article', 'Hair Science', 'Understanding the hair growth cycle helps set realistic expectations. Hair grows in three phases: Anagen (growth phase, lasts 2-7 years), Catagen (transition phase, 2-3 weeks), and Telogen (resting/shedding phase, 3 months). About 90% of your hair is in the growth phase at any time. The average growth rate is 0.5 inches per month or 6 inches per year. Factors affecting growth include genetics, age, overall health, diet, stress levels, and hair care practices. While you cannot speed up your genetic growth rate, you can maximize length retention by preventing breakage. Focus on healthy practices rather than chasing faster growth.', 'https://www.medicalnewstoday.com/articles/hair-growth-cycle', 'https://www.medicalnewstoday.com/content/images/hair-cycle.jpg', 'Dr. Marcus Johnson', '2025-01-25', 0, 1, 9, '2025-12-12 16:04:09'),
(7, 'Scalp Health Fundamentals', 'guide', 'Scalp Health', 'A healthy scalp is the foundation of healthy hair growth. Your scalp needs regular care: massage for 3-5 minutes daily to stimulate blood flow and reduce stress. Keep your scalp clean but don\'t over-wash, which strips natural oils. Exfoliate monthly with a scalp scrub to remove dead skin and product buildup. Watch for warning signs: excessive itching, flaking, redness, tenderness, or bumps. Balance is crucial - oily scalps need lighter products and more frequent washing, while dry scalps need more moisture and less frequent washing. Consider using scalp-specific oils, serums, or treatments targeting your concerns. Remember: your scalp health directly impacts hair health and growth potential.', 'https://www.webmd.com/beauty/healthy-scalp', 'https://www.webmd.com/images/scalp-health.jpg', 'Tiana Williams', '2025-02-10', 0, 1, 8, '2025-12-12 16:04:09'),
(8, 'Protein-Moisture Balance', 'article', 'Hair Science', 'Healthy hair requires both protein and moisture in the right balance for your specific hair type. Protein strengthens the hair structure and repairs damage by temporarily filling in gaps in the cuticle. Moisture keeps hair hydrated, soft, and flexible. Too much protein without moisture causes hard, brittle, straw-like hair that breaks easily. Too much moisture without protein causes mushy, limp, overly stretchy hair. Signs you need protein: excessive elasticity when wet, limpness, difficulty holding styles, increased shedding. Signs you need moisture: dryness, brittleness, dullness, breakage, rough texture. The key is alternating treatments based on how your hair responds. High porosity and damaged hair generally need more frequent protein treatments.', 'https://www.naturallycurly.com/curlreading/curl-products/protein-moisture-balance-explained', 'https://www.naturallycurly.com/wp-content/uploads/protein-moisture.jpg', 'Kenya Roberts', '2025-01-18', 0, 1, 10, '2025-12-12 16:04:09'),
(9, 'Nighttime Hair Care Routine', 'guide', 'Hair Care Techniques', 'A proper nighttime routine prevents breakage, retains moisture, and protects your hair while you sleep. The key steps include: 1) Apply a light leave-in conditioner or oil to seal in moisture. 2) Protective styling - use satin/silk scrunchies for pineappling (high loose ponytail) or gentle twists/braids. 3) Cover with a satin bonnet or sleep on a satin/silk pillowcase - this is NON-NEGOTIABLE. Cotton pillowcases create friction causing breakage and absorb your hair\'s moisture. 4) For extra dry hair, apply a heavier sealant on ends. 5) In the morning, simply remove your bonnet, take down your style, and fluff. Your hair will thank you with less breakage, better moisture retention, and defined styles that last longer.', 'https://www.youtube.com/watch?v=y7jKLhB2FnM', 'https://img.youtube.com/vi/y7jKLhB2FnM/maxresdefault.jpg', 'Jasmine Foster', '2025-02-15', 0, 1, 6, '2025-12-12 17:18:20'),
(10, 'Pre-Poo Treatment Guide', 'tutorial', 'Hair Care Techniques', 'Pre-poo (pre-shampoo) treatments protect your hair from moisture loss during cleansing and make detangling easier. How it works: Before washing, apply oil or a conditioning treatment to dry or damp hair. Popular pre-poo options include coconut oil, olive oil, avocado oil, or a mixture with conditioner. Focus application on your ends where hair is oldest and most fragile. Let it sit for 15-60 minutes (longer is better, some people do overnight). The oil creates a barrier preventing excessive moisture loss during shampooing. When you wash, the shampoo removes dirt and buildup but the oil helps retain your hair\'s natural moisture. This is especially important if using clarifying shampoos or if you have low porosity hair that loses moisture easily. After pre-poo, proceed with your normal wash routine. You\'ll notice hair is softer, more manageable, and experiences less breakage during detangling.', 'https://www.naturallycurly.com/curlreading/home/pre-poo-treatments-what-why-and-how', 'https://www.naturallycurly.com/wp-content/uploads/pre-poo-treatment.jpg', 'Dr. Amara Chen', '2025-01-30', 0, 1, 7, '2025-12-12 17:18:20'),
(11, 'Understanding Porosity and Product Selection', 'article', 'Hair Science', 'Hair porosity is the key to understanding which products and techniques work best for your hair. It determines everything from how you apply products to how often you should deep condition. Low porosity hair has tightly closed cuticles making it resistant to moisture absorption but great at retaining it once inside. Signs: Products sit on top, hair takes forever to dry, water beads up. Best practices: Use heat when deep conditioning to open cuticles, use lighter products that won\'t build up, try steam treatments. High porosity hair has gaps in the cuticle causing it to absorb water quickly but lose it just as fast. Signs: Hair dries quickly, feels dry soon after moisturizing, prone to frizz. Best practices: Use heavier oils and butters to seal moisture, try the LOC or LCO method, use protein treatments to temporarily fill gaps, finish with cool water rinses to close cuticles. Medium porosity is the easiest to manage - it balances moisture well. To test your porosity: Place a clean strand in room temperature water. Floats = low porosity, slowly sinks = medium, sinks quickly = high.', 'https://www.healthline.com/health/beauty-skin-care/hair-porosity', 'https://www.healthline.com/hlcmsresource/images/hair-porosity.jpg', 'Kenya Roberts', '2025-02-08', 0, 1, 9, '2025-12-12 17:18:20'),
(12, 'Wash Day Routine Breakdown', 'tutorial', 'Hair Care Techniques', 'An effective wash day routine ensures thorough cleansing while maintaining moisture and minimizing damage. Here\'s a complete breakdown: 1) PRE-POO (30-60 min): Apply oil to dry hair, focusing on ends. 2) DETANGLE: Using fingers then wide-tooth comb on sections with the pre-poo still in. This is crucial - never detangle dry hair or during shampooing. 3) SHAMPOO: Focus on scalp, use fingertips (not nails) to massage. Let the shampoo running down clean the length. Only shampoo the length if you have significant buildup. 4) CONDITION: Apply generously to length and ends (not scalp). Detangle again if needed. Let sit 3-5 minutes. 5) DEEP CONDITION (weekly): Apply to damp hair, cover with plastic cap, add heat for 20-30 minutes. This penetrates the hair shaft. 6) RINSE: Use cool water for final rinse to seal cuticles. 7) STYLE ON DAMP HAIR: Apply leave-in, oil, and cream (LOC method) while hair is still very damp. 8) AIR DRY or use diffuser on cool/low heat. Never rub with towel - squeeze or use microfiber towel/t-shirt. Wash day frequency depends on your hair: oily scalp (weekly), normal (every 1-2 weeks), very dry (every 2-3 weeks).', 'https://www.youtube.com/watch?v=mNDUMLsPK7I', 'https://img.youtube.com/vi/mNDUMLsPK7I/maxresdefault.jpg', 'Kenya Roberts', '2025-02-20', 0, 1, 10, '2025-12-12 17:18:20'),
(13, 'How to Use the Greenhouse Effect', 'tutorial', 'Hair Care Techniques', 'The greenhouse effect is a heat-trapping technique that helps deep conditioners penetrate better, especially for low porosity hair. After applying your deep conditioner, cover your hair with a plastic cap or bag. Then wrap a warm towel around it or use a hooded dryer. The heat opens your cuticles allowing the treatment to penetrate deeper. Leave on for 20-45 minutes. This method is game-changing for those who struggle with moisture retention.', 'https://www.youtube.com/watch?v=zYAlRasfvvE', 'https://img.youtube.com/vi/zYAlRasfvvE/maxresdefault.jpg', 'Tiana Williams', '2025-02-12', 0, 1, 6, '2025-12-12 21:48:40'),
(14, 'Understanding Hair Growth Vitamins', 'article', 'Hair Science', 'Common hair growth supplements include Biotin (B7), Vitamin D, Iron, Zinc, and Vitamin E. However, supplements only help if you have a deficiency. Taking biotin when you\'re not deficient won\'t make your hair grow faster. Signs you might benefit: excessive shedding, slow growth, brittle nails, fatigue. Always consult a doctor before starting supplements as some can interfere with medications or lab results.', 'https://www.healthline.com/nutrition/best-vitamins-hair-growth', 'https://www.healthline.com/hlcmsresource/images/hair-vitamins.jpg', 'Dr. Marcus Johnson', '2025-01-28', 0, 1, 8, '2025-12-12 21:48:40'),
(15, 'CGM: The Curly Girl Method', 'guide', 'Hair Care Techniques', 'The Curly Girl Method is a haircare routine designed to enhance natural curls and waves. Core principles: No sulfates (harsh cleansers), no silicones (buildup), no heat styling, no brushing dry hair. Instead: co-wash or use sulfate-free shampoo, scrunch in products, air dry or diffuse, \"plop\" to enhance curls. While not for everyone, many curly-haired people find this method transforms their hair, giving definition and reducing frizz.', 'https://www.naturallycurly.com/curlreading/no-poo/the-curly-girl-method-for-coily-hair', 'https://www.naturallycurly.com/wp-content/uploads/curly-girl-method.jpg', 'Kenya Roberts', '2025-02-18', 0, 1, 12, '2025-12-12 21:48:40'),
(16, 'How to Do a Protein Treatment', 'tutorial', 'Hair Care Techniques', 'Protein treatments strengthen hair by temporarily filling gaps in damaged cuticles. Use when hair feels mushy, limp, overly stretchy when wet, or won\'t hold styles. How to: 1) Start with clarified hair. 2) Apply protein treatment to damp hair. 3) Cover with cap. 4) Follow product timing (15-30 min). 5) Rinse thoroughly. 6) ALWAYS follow with moisture treatment or deep conditioner. Don\'t overdo it - most people need protein every 2-4 weeks max.', 'https://www.youtube.com/watch?v=pvAetJ7GC3U', 'https://img.youtube.com/vi/pvAetJ7GC3U/maxresdefault.jpg', 'Dr. Amara Chen', '2025-02-03', 0, 1, 7, '2025-12-12 21:48:40'),
(17, 'Moisturizing vs. Hydrating Hair', 'article', 'Hair Science', 'These terms are often confused but mean different things. Hydrating adds WATER to your hair - think water-based leave-ins, aloe vera juice. Moisturizing adds OILS and BUTTERS that lock in hydration - think shea butter, coconut oil. Your hair needs BOTH: first hydrate with water-based products, then moisturize/seal with oils. This is why the LOC method works: Liquid (hydrate), Oil (seal), Cream (moisturize and lock everything in).', 'https://www.allure.com/story/difference-between-hydrating-and-moisturizing-hair', 'https://www.allure.com/images/hair-hydration.jpg', 'Jasmine Foster', '2025-01-22', 0, 1, 5, '2025-12-12 21:48:40'),
(18, 'How to Refresh Curls Between Wash Days', 'tutorial', 'Styling', 'Refreshing extends your style without full washing. Day 2-5 hair can look great with proper refreshing. Method: 1) Lightly dampen hair with water spray or leave-in conditioner mix. 2) Scrunch to reactivate products and reform curl clumps. 3) Add small amount of curl cream or gel if needed. 4) Diffuse briefly or air dry. 5) Fluff roots for volume. For very defined curls, you can re-twist or re-braid sections overnight. The key is adding just enough moisture without making hair soaking wet.', 'https://www.youtube.com/watch?v=qNjHiVrdEPU', 'https://img.youtube.com/vi/qNjHiVrdEPU/maxresdefault.jpg', 'Tiana Williams', '2025-02-07', 0, 1, 5, '2025-12-12 21:48:40'),
(19, 'Trimming vs. Dusting: What\'s the Difference?', 'guide', 'Hair Care Techniques', 'Trimming removes 1/4 to 1/2 inch or more to cut off damaged ends. Done every 8-12 weeks or as needed. Dusting is ultra-light maintenance where you remove only 1/8 inch or less, just the very tips showing damage. Done every 6-8 weeks. Search and Destroy is going through your hair strand by strand cutting off only visible splits without removing length. Best for length retention while maintaining health.', 'https://www.byrdie.com/how-to-trim-your-hair-at-home', 'https://www.byrdie.com/thmb/trim-hair.jpg', 'Kenya Roberts', '2025-02-14', 0, 1, 6, '2025-12-12 21:48:40'),
(20, 'Heat Training: Myths and Reality', 'article', 'Hair Science', 'Heat training is the controversial practice of using heat regularly to loosen curl pattern. Reality: Heat training is controlled heat DAMAGE. You\'re permanently altering your hair structure. It can work for some who want looser curls, but risks include: uneven results, heat damage, breakage, and permanently straight sections. If you choose to heat train: use heat protectant always, low-medium heat only, consistent technique, protein treatments, and accept that it\'s permanent damage (though new growth will be your natural texture).', 'https://www.naturallycurly.com/curlreading/kinky-hair-type-4a/heat-training-is-it-safe', 'https://www.naturallycurly.com/wp-content/uploads/heat-training.jpg', 'Dr. Marcus Johnson', '2025-01-19', 0, 1, 10, '2025-12-12 21:48:40');

-- --------------------------------------------------------

--
-- Table structure for table `growth_forecasts`
--

CREATE TABLE `growth_forecasts` (
  `forecast_id` int NOT NULL,
  `profile_id` int NOT NULL,
  `forecast_date` date NOT NULL,
  `predicted_length` decimal(5,2) NOT NULL,
  `confidence_level` decimal(3,2) DEFAULT NULL,
  `based_on_data_points` int DEFAULT '0',
  `growth_rate_per_month` decimal(4,2) DEFAULT NULL,
  `notes` text COLLATE utf8mb4_general_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ;

--
-- Dumping data for table `growth_forecasts`
--

INSERT INTO `growth_forecasts` (`forecast_id`, `profile_id`, `forecast_date`, `predicted_length`, `confidence_level`, `based_on_data_points`, `growth_rate_per_month`, `notes`, `created_at`) VALUES
(19, 11, '2026-01-13', 29.50, 0.17, 2, -9.00, 'Based on 2 data points. Average growth rate: -9.00 inches/month.', '2025-12-13 23:51:34'),
(20, 11, '2026-02-13', 20.50, 0.17, 2, -9.00, 'Based on 2 data points. Average growth rate: -9.00 inches/month.', '2025-12-13 23:51:34'),
(21, 11, '2026-03-13', 11.50, 0.17, 2, -9.00, 'Based on 2 data points. Average growth rate: -9.00 inches/month.', '2025-12-13 23:51:34'),
(22, 11, '2026-04-13', 2.50, 0.17, 2, -9.00, 'Based on 2 data points. Average growth rate: -9.00 inches/month.', '2025-12-13 23:51:34'),
(23, 11, '2026-05-13', 0.00, 0.17, 2, -9.00, 'Based on 2 data points. Average growth rate: -9.00 inches/month.', '2025-12-13 23:51:34'),
(24, 11, '2026-06-13', 0.00, 0.17, 2, -9.00, 'Based on 2 data points. Average growth rate: -9.00 inches/month.', '2025-12-13 23:51:34');

-- --------------------------------------------------------

--
-- Table structure for table `growth_methods`
--

CREATE TABLE `growth_methods` (
  `method_id` int NOT NULL,
  `method_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `category` enum('protective_styling','scalp_care','nutrition','trimming','massage','treatment','lifestyle','hot_oil','deep_conditioning','inversion','supplements','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `frequency` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `duration` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `difficulty_level` enum('beginner','intermediate','advanced') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `expected_results` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `instructions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `video_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `scientific_backing` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `success_rate` decimal(3,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `growth_methods`
--

INSERT INTO `growth_methods` (`method_id`, `method_name`, `category`, `description`, `frequency`, `duration`, `difficulty_level`, `expected_results`, `instructions`, `video_url`, `scientific_backing`, `success_rate`) VALUES
(1, 'Scalp Massage', 'massage', 'Stimulate blood flow to promote hair growth', 'Daily', '5-10 minutes', 'beginner', 'Improved circulation, potential growth boost', 'Use fingertips to gently massage scalp in circular motions for 5-10 minutes daily', 'https://www.youtube.com/watch?v=J9aSXxxKLn0', 'Studies show scalp massage can increase hair thickness by stimulating dermal papilla cells and promoting follicle stretch. Improves blood circulation delivering nutrients to follicles.', 0.70),
(2, 'Protective Styling', 'protective_styling', 'Styles that protect ends from damage', 'Weekly', 'Varies', 'intermediate', 'Reduced breakage, length retention', 'Braid, twist, or bun hair to protect ends. Keep styles for 1-2 weeks', 'https://www.youtube.com/watch?v=I7hL0NkIgVc', 'Well-documented method for length retention. Reduces mechanical damage and environmental exposure. Protects fragile ends from breakage.', 0.85),
(3, 'Deep Conditioning', 'treatment', 'Intensive moisture treatment', 'Weekly', '30-60 minutes', 'beginner', 'Improved moisture, reduced breakage', 'Apply conditioner, cover with cap, apply heat for 15-30 min, then rinse', 'https://www.youtube.com/watch?v=t35dJvL3Ofk', 'Penetrative conditioners repair damage, improve elasticity, and reduce protein loss. Heat opens cuticles for deeper penetration.', 0.88),
(4, 'Low Manipulation', 'lifestyle', 'Minimize handling and styling', 'Daily', 'Ongoing', 'beginner', 'Less breakage, length retention', 'Avoid daily styling, use gentle techniques, protective styles', 'https://www.youtube.com/shorts/4f1k0ti6q2c', 'Reduces mechanical damage from styling. Minimizes breakage from manipulation. Proven to improve length retention.', 0.80),
(5, 'Regular Trims', 'trimming', 'Remove split ends regularly', 'Every 8-12 weeks', '15 minutes', 'beginner', 'Healthy ends, prevent further damage', 'Trim 1/4 to 1/2 inch every 8-12 weeks to maintain healthy ends', 'https://www.youtube.com/shorts/jGUY60jcmvw', 'Split ends cannot be repaired and continue splitting up the shaft. Regular trims maintain hair health and prevent further damage.', 0.90),
(6, 'Hot Oil Treatment', 'treatment', 'Nourish hair with warm oils', 'Bi-weekly', '30-45 minutes', 'beginner', 'Improved moisture and shine', 'Warm oil (coconut, olive, or castor), apply to hair, cover for 30 min, rinse', 'https://www.youtube.com/watch?v=hGvDo0JBG5o', 'Oils penetrate hair shaft when warmed. Coconut oil particularly effective at reducing protein loss. Improves moisture retention.', 0.78),
(8, 'Inversion Method', 'inversion', 'Hanging head upside down to increase blood flow to scalp, combined with massage and oils.', 'Weekly, 7 consecutive days', '4 minutes per session', 'beginner', 'Some users report up to 1 inch of growth per week, though results vary widely.', '1. Warm oil. 2. Massage oil into scalp 3-4 minutes. 3. Flip head upside down. 4. Maintain position for 4 minutes. 5. Flip back slowly. 6. Repeat for 7 days. 7. Take 3-4 week breaks between cycles.', 'https://www.youtube.com/watch?v=PjqmZkiyL6o', 'Limited scientific evidence. Theory based on increased blood flow.', 0.45),
(11, 'Protein Treatment', 'treatment', 'Protein-rich products to strengthen hair structure and repair damage.', 'Every 2-4 weeks', '15-30 minutes', 'intermediate', 'Stronger hair, reduced breakage, improved elasticity. Results visible after first treatment.', '1. Use after clarifying. 2. Apply to damp hair. 3. Cover with cap. 4. Follow timing instructions. 5. Apply heat if directed. 6. Rinse thoroughly. 7. Always follow with moisture. 8. Monitor response.', 'https://www.youtube.com/shorts/WdCiOyZFHmE', 'Temporarily repairs broken disulfide bonds, restoring strength. Most effective for damaged hair.', 0.82),
(13, 'Rice Water Rinse', 'treatment', 'Traditional Asian beauty treatment using rice water to strengthen and add shine.', 'Weekly or bi-weekly', '15-30 minute soak', 'beginner', 'Increased shine, improved elasticity, smoother texture within 4-8 weeks.', '1. Rinse rice. 2. Soak in water 30 minutes to overnight. 3. Strain liquid. 4. Optional: ferment 12-24 hours. 5. Pour over shampooed hair. 6. Massage in. 7. Leave 15-30 minutes. 8. Rinse thoroughly. 9. Condition.', 'https://www.youtube.com/shorts/b0QLGZ0Riz0', 'Rice water contains inositol which penetrates damaged hair. Historical use with documented results.', 0.68),
(14, 'Biotin Supplements', 'supplements', 'Daily B-vitamin supplement believed to support healthy hair growth.', 'Daily', 'Minimum 3-6 months', 'beginner', 'Potentially thicker hair, faster growth. Results vary; most effective for deficiency.', '1. Consult healthcare provider. 2. Typical dose: 2500-5000 mcg daily. 3. Take with food. 4. Stay consistent 3+ months. 5. Monitor side effects. 6. Combine with balanced diet. 7. Be patient.', 'https://www.youtube.com/shorts/EdlG3FHyIT8', 'Mixed evidence. Helps if deficient. Limited evidence for non-deficient individuals.', 0.55),
(16, 'Overnight Treatment', 'treatment', 'Intensive overnight conditioning or oil treatment for maximum penetration.', 'Weekly or bi-weekly', '6-8 hours overnight', 'beginner', 'Deeply hydrated hair, improved softness. Effective for very dry or high-porosity hair.', '1. Apply conditioner or oil to damp hair. 2. Focus on ends. 3. Twist or braid sections. 4. Cover with bonnet. 5. Optional: plastic cap under bonnet. 6. Sleep comfortably. 7. Rinse in morning. 8. Style as desired.', 'https://www.youtube.com/watch?v=ES4zRT7dhXY', 'Extended time allows maximum penetration. Effective for dry, damaged hair.', 0.78),
(17, 'Green Tea Rinse', 'treatment', 'Natural rinse using green tea to reduce shedding and stimulate follicles.', 'Weekly or bi-weekly', '15-20 minute rinse', 'beginner', 'Reduced shedding, potential growth stimulation. Many report less hair loss within 4-6 weeks.', '1. Steep 2-3 tea bags in 2 cups water. 2. Cool to lukewarm. 3. Pour over shampooed hair. 4. Massage scalp 5 minutes. 5. Let sit 10-15 minutes. 6. Rinse with cool water. 7. Condition. 8. Can refrigerate 3-4 days.', 'https://www.youtube.com/watch?v=ErWtzVCWW2o', 'Green tea contains EGCG which may block DHT. Antioxidants support scalp health.', 0.72),
(18, 'LOC Method', 'treatment', 'Layering technique: Liquid, Oil, Cream to seal in maximum moisture.', 'After every wash', '10-15 minutes', 'beginner', 'Better moisture retention, softer hair, reduced dryness especially for type 4 hair.', '1. Apply water-based leave-in to damp hair. 2. Apply oil to seal moisture. 3. Apply cream to lock everything. 4. Use on freshly washed hair. 5. Focus on ends. 6. Can modify to LCO if needed.', 'https://www.youtube.com/shorts/VxEswzop6zc', 'Layering products traps moisture. Proven effective for type 4 and high porosity hair.', 0.82);

-- --------------------------------------------------------

--
-- Table structure for table `growth_milestones`
--

CREATE TABLE `growth_milestones` (
  `milestone_id` int NOT NULL,
  `profile_id` int NOT NULL,
  `milestone_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `target_length` decimal(5,2) DEFAULT NULL,
  `target_date` date DEFAULT NULL,
  `is_achieved` tinyint(1) DEFAULT '0',
  `achieved_date` date DEFAULT NULL,
  `celebration_message` text COLLATE utf8mb4_general_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hair_care_routines`
--

CREATE TABLE `hair_care_routines` (
  `routine_id` int NOT NULL,
  `profile_id` int NOT NULL,
  `routine_name` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `routine_type` enum('morning','night','wash_day','weekly','bi-weekly','monthly','custom') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `is_active` tinyint(1) DEFAULT '1',
  `last_update_alert` date DEFAULT NULL,
  `update_frequency_days` int DEFAULT '90',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hair_care_routines`
--

INSERT INTO `hair_care_routines` (`routine_id`, `profile_id`, `routine_name`, `routine_type`, `description`, `is_active`, `last_update_alert`, `update_frequency_days`, `created_at`, `updated_at`) VALUES
(10, 3, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 1B - Straight Medium hair type', 1, '2025-12-12', 90, '2025-12-12 21:30:16', '2025-12-12 21:30:16'),
(11, 3, 'Night Routine', 'night', 'Personalized night hair care routine for Type 1B - Straight Medium hair type', 1, '2025-12-12', 90, '2025-12-12 21:30:16', '2025-12-12 21:30:16'),
(12, 3, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 1B - Straight Medium hair type', 1, '2025-12-12', 90, '2025-12-12 21:30:16', '2025-12-12 21:30:16'),
(13, 4, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 4C - Coily Tight hair type', 1, '2025-12-12', 90, '2025-12-12 22:10:22', '2025-12-12 22:10:22'),
(14, 4, 'Night Routine', 'night', 'Personalized night hair care routine for Type 4C - Coily Tight hair type', 1, '2025-12-12', 90, '2025-12-12 22:10:22', '2025-12-12 22:10:22'),
(15, 4, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 4C - Coily Tight hair type', 1, '2025-12-12', 90, '2025-12-12 22:10:22', '2025-12-12 22:10:22'),
(10, 3, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 1B - Straight Medium hair type', 1, '2025-12-12', 90, '2025-12-12 21:30:16', '2025-12-12 21:30:16'),
(11, 3, 'Night Routine', 'night', 'Personalized night hair care routine for Type 1B - Straight Medium hair type', 1, '2025-12-12', 90, '2025-12-12 21:30:16', '2025-12-12 21:30:16'),
(12, 3, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 1B - Straight Medium hair type', 1, '2025-12-12', 90, '2025-12-12 21:30:16', '2025-12-12 21:30:16'),
(13, 4, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 4C - Coily Tight hair type', 1, '2025-12-12', 90, '2025-12-12 22:10:22', '2025-12-12 22:10:22'),
(14, 4, 'Night Routine', 'night', 'Personalized night hair care routine for Type 4C - Coily Tight hair type', 1, '2025-12-12', 90, '2025-12-12 22:10:22', '2025-12-12 22:10:22'),
(15, 4, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 4C - Coily Tight hair type', 1, '2025-12-12', 90, '2025-12-12 22:10:22', '2025-12-12 22:10:22'),
(16, 6, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:39:44', '2025-12-12 23:47:02'),
(17, 6, 'Night Routine', 'night', 'Personalized night hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:39:44', '2025-12-12 23:47:02'),
(18, 6, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:39:44', '2025-12-12 23:47:02'),
(19, 6, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:02', '2025-12-12 23:47:07'),
(20, 6, 'Night Routine', 'night', 'Personalized night hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:02', '2025-12-12 23:47:07'),
(21, 6, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:02', '2025-12-12 23:47:07'),
(22, 6, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:07', '2025-12-12 23:47:10'),
(23, 6, 'Night Routine', 'night', 'Personalized night hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:07', '2025-12-12 23:47:10'),
(24, 6, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:07', '2025-12-12 23:47:10'),
(25, 6, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:10', '2025-12-12 23:47:13'),
(26, 6, 'Night Routine', 'night', 'Personalized night hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:10', '2025-12-12 23:47:13'),
(27, 6, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:10', '2025-12-12 23:47:13'),
(28, 6, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:13', '2025-12-12 23:49:08'),
(29, 6, 'Night Routine', 'night', 'Personalized night hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:13', '2025-12-12 23:49:08'),
(30, 6, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:13', '2025-12-12 23:49:08'),
(31, 6, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 4A - Coily Soft hair type', 1, '2025-12-12', 90, '2025-12-12 23:49:08', '2025-12-12 23:49:08'),
(32, 6, 'Night Routine', 'night', 'Personalized night hair care routine for Type 4A - Coily Soft hair type', 1, '2025-12-12', 90, '2025-12-12 23:49:08', '2025-12-12 23:49:08'),
(33, 6, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 4A - Coily Soft hair type', 1, '2025-12-12', 90, '2025-12-12 23:49:08', '2025-12-12 23:49:08'),
(34, 5, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 2B - Wavy Medium hair type', 1, '2025-12-12', 90, '2025-12-12 23:49:16', '2025-12-12 23:49:16'),
(35, 5, 'Night Routine', 'night', 'Personalized night hair care routine for Type 2B - Wavy Medium hair type', 1, '2025-12-12', 90, '2025-12-12 23:49:16', '2025-12-12 23:49:16'),
(36, 5, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 2B - Wavy Medium hair type', 1, '2025-12-12', 90, '2025-12-12 23:49:16', '2025-12-12 23:49:16'),
(10, 3, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 1B - Straight Medium hair type', 1, '2025-12-12', 90, '2025-12-12 21:30:16', '2025-12-12 21:30:16'),
(11, 3, 'Night Routine', 'night', 'Personalized night hair care routine for Type 1B - Straight Medium hair type', 1, '2025-12-12', 90, '2025-12-12 21:30:16', '2025-12-12 21:30:16'),
(12, 3, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 1B - Straight Medium hair type', 1, '2025-12-12', 90, '2025-12-12 21:30:16', '2025-12-12 21:30:16'),
(13, 4, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 4C - Coily Tight hair type', 1, '2025-12-12', 90, '2025-12-12 22:10:22', '2025-12-12 22:10:22'),
(14, 4, 'Night Routine', 'night', 'Personalized night hair care routine for Type 4C - Coily Tight hair type', 1, '2025-12-12', 90, '2025-12-12 22:10:22', '2025-12-12 22:10:22'),
(15, 4, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 4C - Coily Tight hair type', 1, '2025-12-12', 90, '2025-12-12 22:10:22', '2025-12-12 22:10:22'),
(16, 6, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:39:44', '2025-12-12 23:47:02'),
(17, 6, 'Night Routine', 'night', 'Personalized night hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:39:44', '2025-12-12 23:47:02'),
(18, 6, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:39:44', '2025-12-12 23:47:02'),
(19, 6, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:02', '2025-12-12 23:47:07'),
(20, 6, 'Night Routine', 'night', 'Personalized night hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:02', '2025-12-12 23:47:07'),
(21, 6, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:02', '2025-12-12 23:47:07'),
(22, 6, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:07', '2025-12-12 23:47:10'),
(23, 6, 'Night Routine', 'night', 'Personalized night hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:07', '2025-12-12 23:47:10'),
(24, 6, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:07', '2025-12-12 23:47:10'),
(25, 6, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:10', '2025-12-12 23:47:13'),
(26, 6, 'Night Routine', 'night', 'Personalized night hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:10', '2025-12-12 23:47:13'),
(27, 6, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:10', '2025-12-12 23:47:13'),
(28, 6, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:13', '2025-12-12 23:49:08'),
(29, 6, 'Night Routine', 'night', 'Personalized night hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:13', '2025-12-12 23:49:08'),
(30, 6, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 4A - Coily Soft hair type', 0, '2025-12-12', 90, '2025-12-12 23:47:13', '2025-12-12 23:49:08'),
(31, 6, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 4A - Coily Soft hair type', 1, '2025-12-12', 90, '2025-12-12 23:49:08', '2025-12-12 23:49:08'),
(32, 6, 'Night Routine', 'night', 'Personalized night hair care routine for Type 4A - Coily Soft hair type', 1, '2025-12-12', 90, '2025-12-12 23:49:08', '2025-12-12 23:49:08'),
(33, 6, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 4A - Coily Soft hair type', 1, '2025-12-12', 90, '2025-12-12 23:49:08', '2025-12-12 23:49:08'),
(34, 5, 'Morning Routine', 'morning', 'Personalized morning hair care routine for Type 2B - Wavy Medium hair type', 1, '2025-12-12', 90, '2025-12-12 23:49:16', '2025-12-12 23:49:16'),
(35, 5, 'Night Routine', 'night', 'Personalized night hair care routine for Type 2B - Wavy Medium hair type', 1, '2025-12-12', 90, '2025-12-12 23:49:16', '2025-12-12 23:49:16'),
(36, 5, 'Wash_day Routine', 'wash_day', 'Personalized wash_day hair care routine for Type 2B - Wavy Medium hair type', 1, '2025-12-12', 90, '2025-12-12 23:49:16', '2025-12-12 23:49:16'),
(37, 10, 'Morning Routine', 'morning', 'Personalized morning routine', 1, '2025-12-14', 90, '2025-12-14 00:34:27', '2025-12-14 00:34:27'),
(38, 10, 'Night Routine', 'night', 'Personalized night routine', 1, '2025-12-14', 90, '2025-12-14 00:34:27', '2025-12-14 00:34:27'),
(39, 10, 'Wash day Routine', 'wash_day', 'Personalized wash_day routine', 1, '2025-12-14', 90, '2025-12-14 00:34:27', '2025-12-14 00:34:27'),
(40, 11, 'Morning Routine', 'morning', 'Personalized morning routine', 1, '2025-12-14', 90, '2025-12-14 00:34:51', '2025-12-14 00:34:51'),
(41, 11, 'Night Routine', 'night', 'Personalized night routine', 1, '2025-12-14', 90, '2025-12-14 00:34:51', '2025-12-14 00:34:51'),
(42, 11, 'Wash day Routine', 'wash_day', 'Personalized wash_day routine', 1, '2025-12-14', 90, '2025-12-14 00:34:51', '2025-12-14 00:34:51'),
(43, 12, 'Morning Routine', 'morning', 'Personalized morning routine', 1, '2025-12-14', 90, '2025-12-14 00:56:13', '2025-12-14 00:56:13'),
(44, 12, 'Night Routine', 'night', 'Personalized night routine', 1, '2025-12-14', 90, '2025-12-14 00:56:13', '2025-12-14 00:56:13'),
(45, 12, 'Wash day Routine', 'wash_day', 'Personalized wash_day routine', 1, '2025-12-14', 90, '2025-12-14 00:56:13', '2025-12-14 00:56:13');

-- --------------------------------------------------------

--
-- Table structure for table `hair_concerns`
--

CREATE TABLE `hair_concerns` (
  `concern_id` int NOT NULL,
  `concern_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `severity_level` enum('mild','moderate','severe') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `common_causes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `symptoms` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `hair_concerns`
--

INSERT INTO `hair_concerns` (`concern_id`, `concern_name`, `description`, `severity_level`, `common_causes`, `symptoms`) VALUES
(1, 'Hair Loss', 'Excessive loss of hair strands beyond the normal 50-100 hairs per day, leading to noticeable thinning.', 'moderate', 'Hormonal imbalances, stress, nutritional deficiencies, medications, postpartum changes, thyroid issues, traction from tight styles', 'More than 100 hairs shed daily, hair in drain/brush, visible thinning, widening part, decreased ponytail thickness'),
(2, 'Breakage', 'Hair strands snapping or breaking off at various points along the shaft, preventing length retention.', 'moderate', 'Protein-moisture imbalance, heat damage, mechanical damage, rough handling, chemical treatments, lack of moisture', 'Short broken hairs throughout, uneven lengths, hair snapping when stretched, rough texture, visible damage'),
(3, 'Dryness', 'Hair lacking adequate moisture, feeling rough and straw-like to the touch.', 'mild', 'Low porosity, harsh products, over-washing, environmental factors, heat styling, lack of sealing', 'Rough texture, dull appearance, lack of shine, difficulty retaining moisture, frizz, tangles easily'),
(4, 'Frizz', 'Unruly, frizzy hair that lacks smoothness and definition.', 'mild', 'Humidity, high porosity, cuticle damage, lack of moisture, wrong products, cotton pillowcases', 'Halo of frizz, undefined curls, puffiness, hair stands up, difficult to smooth, static'),
(5, 'Split Ends', 'Hair ends splitting into two or more strands, indicating damage.', 'mild', 'Heat damage, mechanical damage, neglecting trims, over-manipulation, harsh styling, chemical treatments', 'Forked ends, frayed appearance, white dots on ends, rough tips, tangling at ends'),
(6, 'Scalp Issues', 'Various scalp conditions including dandruff, itching, flaking, or irritation.', 'moderate', 'Product buildup, fungal infection, seborrheic dermatitis, dry scalp, allergic reactions, psoriasis', 'Flaking, itching, redness, tenderness, bumps, irritation, scaling, oiliness or dryness'),
(7, 'Slow Growth', 'Hair not growing at the expected rate of approximately 0.5 inches per month.', 'moderate', 'Breakage equals growth, poor circulation, nutritional deficiencies, hormonal issues, genetics, stress', 'No visible length increase over months, hair seems stuck at same length'),
(8, 'Thinning', 'Gradual decrease in hair density with visible scalp becoming apparent.', 'severe', 'Genetics, hormonal changes, aging, traction alopecia, medical conditions, medications, stress', 'Wider part line, visible scalp, decreased density, receding hairline, thinner ponytail, bald patches'),
(9, 'Damage', 'Overall compromised hair health from heat styling or chemical treatments.', 'moderate', 'Heat styling, chemical relaxers, color treatments, bleaching, perms, lack of protein, over-processing', 'Brittle texture, breakage, loss of curl pattern, dryness, split ends, rough feel, dullness'),
(10, 'Lack of Shine', 'Hair appearing dull and lifeless without healthy luster.', 'mild', 'Cuticle damage, product buildup, hard water, lack of moisture, over-styling, poor diet', 'Matte appearance, no light reflection, looks unhealthy, rough texture, lacks vibrancy'),
(21, 'Excessive Breakage', 'Hair strands snapping or breaking off, particularly at mid-shaft or ends, leading to stunted length retention.', 'moderate', 'Protein-moisture imbalance, heat damage, mechanical damage from rough handling, lack of moisture, protein overload, tight hairstyles', 'Short broken hairs, uneven length, hair snapping when stretched, rough texture, split ends'),
(22, 'Dryness and Brittleness', 'Hair feeling rough, straw-like, and lacking moisture, making it prone to breakage and difficult to manage.', 'moderate', 'Low moisture retention, harsh products, over-washing, environmental factors, lack of proper sealing, heat styling', 'Rough texture, dull appearance, frizz, tangling, lack of shine, hair feels straw-like'),
(23, 'Scalp Dandruff', 'Flaking of the scalp skin, which may be accompanied by itching and irritation.', 'mild', 'Dry scalp, product buildup, seborrheic dermatitis, fungal infection, not rinsing thoroughly, harsh shampoos', 'White or yellow flakes, itching, scalp irritation, redness, visible flakes on shoulders'),
(24, 'Excessive Shedding', 'Losing more than the normal 50-100 hairs per day, noticeable hair loss when washing or styling.', 'moderate', 'Stress, hormonal changes, nutritional deficiencies, medication side effects, postpartum, illness, harsh handling', 'Large amounts of hair in brush or drain, visible thinning, hair coming out in clumps, more than 100 hairs shed daily'),
(25, 'Scalp Irritation', 'Uncomfortable sensations on the scalp including itching, burning, tenderness, or pain.', 'moderate', 'Product allergies, tight hairstyles, bacterial or fungal infection, psoriasis, eczema, harsh chemicals, sunburn', 'Itching, burning sensation, redness, tenderness, bumps or sores, flaking, pain when touching scalp'),
(26, 'Thinning Hair', 'Gradual decrease in hair density, with visible scalp becoming more apparent.', 'severe', 'Genetics, hormonal imbalances, aging, stress, nutritional deficiencies, traction alopecia, medical conditions', 'Wider part line, visible scalp, decreased ponytail thickness, receding hairline, overall reduced density');

-- --------------------------------------------------------

--
-- Table structure for table `hair_growth_progress`
--

CREATE TABLE `hair_growth_progress` (
  `progress_id` int NOT NULL,
  `profile_id` int NOT NULL,
  `measurement_date` date NOT NULL,
  `hair_length` decimal(5,2) DEFAULT NULL,
  `hair_health_rating` int DEFAULT NULL,
  `photo_url` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_general_ci,
  `measurement_type` enum('manual','photo_analysis','routine') COLLATE utf8mb4_general_ci DEFAULT 'manual',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ;

--
-- Dumping data for table `hair_growth_progress`
--

INSERT INTO `hair_growth_progress` (`progress_id`, `profile_id`, `measurement_date`, `hair_length`, `hair_health_rating`, `photo_url`, `notes`, `measurement_type`, `created_at`) VALUES
(4, 3, '2025-12-12', 13.00, NULL, NULL, 'Hair is thinning', 'manual', '2025-12-12 21:31:17'),
(5, 3, '2025-12-11', 13.20, NULL, NULL, 'Knotting at the ends', 'manual', '2025-12-12 21:31:36'),
(4, 3, '2025-12-12', 13.00, NULL, NULL, 'Hair is thinning', 'manual', '2025-12-12 21:31:17'),
(5, 3, '2025-12-11', 13.20, NULL, NULL, 'Knotting at the ends', 'manual', '2025-12-12 21:31:36'),
(4, 3, '2025-12-12', 13.00, NULL, NULL, 'Hair is thinning', 'manual', '2025-12-12 21:31:17'),
(5, 3, '2025-12-11', 13.20, NULL, NULL, 'Knotting at the ends', 'manual', '2025-12-12 21:31:36'),
(6, 7, '2025-12-13', 20.00, NULL, NULL, 'yes', 'manual', '2025-12-13 22:33:18'),
(7, 7, '2025-12-12', 21.00, NULL, NULL, 'yes', 'manual', '2025-12-13 22:33:34'),
(8, 7, '2025-12-11', 24.00, NULL, NULL, 'yh', 'manual', '2025-12-13 22:50:58'),
(9, 11, '2025-12-13', 38.50, NULL, NULL, 'fsdg', 'manual', '2025-12-13 23:26:18'),
(10, 11, '2025-12-12', 38.80, NULL, NULL, 'frvg', 'manual', '2025-12-13 23:26:40'),
(11, 12, '2025-12-14', 15.00, NULL, NULL, 'growth', 'manual', '2025-12-14 00:58:16'),
(12, 13, '2025-12-14', 2.00, NULL, NULL, '', 'manual', '2025-12-14 12:01:53');

-- --------------------------------------------------------

--
-- Table structure for table `hair_pitfalls`
--

CREATE TABLE `hair_pitfalls` (
  `pitfall_id` int NOT NULL,
  `pitfall_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `category` enum('product','practice','tool','ingredient','styling','environmental','chemical','heat','manipulation','other') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `why_harmful` text COLLATE utf8mb4_general_ci,
  `severity` enum('low','medium','high','critical') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `alternative_suggestion` text COLLATE utf8mb4_general_ci,
  `long_term_effects` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hair_pitfalls`
--

INSERT INTO `hair_pitfalls` (`pitfall_id`, `pitfall_name`, `category`, `description`, `why_harmful`, `severity`, `alternative_suggestion`, `long_term_effects`) VALUES
(1, 'Regular Elastic Bands', 'tool', 'Using regular rubber bands or tight elastics on hair instead of hair-safe alternatives.', 'Rubber bands snag and break hair, cause breakage at tension points, and can get tangled requiring cutting out.', 'high', 'Use satin scrunchies, spiral hair ties, or soft fabric-covered elastics that don\'t snag.', 'Persistent breakage, damaged hair shaft, possible bald spots at frequent tie locations.'),
(2, 'Daily Heat Styling', 'practice', 'Using flat irons, curling irons, or blow dryers with heat on hair every day.', 'Continuous high heat breaks down protein bonds, strips moisture, and permanently damages hair cuticle.', 'critical', 'Air dry when possible, use heatless styling methods, limit heat to once per week maximum with protectant.', 'Permanently altered texture, chronic dryness, severe breakage, split ends, loss of elasticity.'),
(3, 'Sulfate Shampoos', 'product', 'Regular use of shampoos containing harsh sulfates like SLS or SLES.', 'Sulfates are harsh detergents that strip natural oils, disrupt moisture balance, and cause dryness.', 'medium', 'Switch to sulfate-free shampoos, try co-washing, or use gentler cleansing options.', 'Chronic dryness, color fading, increased frizz, damaged cuticle layer.'),
(4, 'Skipping Heat Protectant', 'practice', 'Applying heat styling tools directly to hair without protective barrier.', 'Unprotected hair experiences direct protein damage, moisture loss, and cuticle destruction from heat.', 'high', 'Always apply heat protectant spray or serum before any heat styling, no exceptions.', 'Irreversible heat damage, brittle hair, severe breakage, permanently altered texture.'),
(5, 'Tight Protective Styles', 'styling', 'Installing braids, weaves, or ponytails with excessive tension on scalp and hairline.', 'Constant tension damages follicles, causes inflammation, and leads to traction alopecia.', 'critical', 'Ensure styles are comfortable, can move fingers under braids, no pain or tightness, no bumps on scalp.', 'Traction alopecia, permanent hair loss at edges and nape, damaged follicles, scarring.'),
(6, 'Sleeping on Cotton Pillowcases', 'practice', 'Using regular cotton pillowcases instead of satin or silk alternatives.', 'Cotton absorbs moisture from hair, creates friction causing breakage, and disturbs curl pattern.', 'medium', 'Use satin or silk pillowcases, or wear a satin bonnet or scarf to bed.', 'Chronic dryness, increased breakage, frizz, loss of curl definition over time.'),
(7, 'Over-Washing', 'practice', 'Washing hair daily or every other day, stripping natural oils.', 'Frequent washing removes sebum needed for protection and moisture, leading to dryness and breakage.', 'medium', 'Wash 1-2 times per week for most hair types, adjust based on activity level and scalp type.', 'Dry scalp, brittle hair, increased breakage, color fading, moisture imbalance.'),
(8, 'Skipping Deep Conditioning', 'practice', 'Only using regular conditioner without weekly deep conditioning treatments.', 'Regular conditioner provides surface moisture but doesn\'t penetrate for lasting hydration and repair.', 'high', 'Deep condition weekly for at least 20 minutes with heat for low porosity, 30+ minutes for high porosity.', 'Cumulative dryness, increased breakage, poor moisture retention, stunted length.'),
(9, 'Combing from Roots', 'practice', 'Starting detangling process at roots and pulling comb down through tangles.', 'Pulling from roots tears through knots, causes breakage, and creates more tangles.', 'high', 'Always detangle from ends working up to roots, use fingers first, then wide-tooth comb on wet hair with conditioner.', 'Excessive breakage, damaged cuticle, split ends, thinning throughout length.'),
(10, 'Protein Without Moisture', 'product', 'Using protein treatments frequently without balancing with moisture treatments.', 'Excess protein without moisture causes hair to become hard, brittle, and prone to snapping.', 'high', 'Always follow protein treatments with moisturizing deep conditioner. Balance is key - most need more moisture than protein.', 'Protein overload, brittle hair that snaps easily, loss of elasticity, severe breakage.'),
(11, 'Chemical Overlapping', 'chemical', 'Applying relaxer or color to previously processed hair, causing overlap.', 'Double processing the same hair section breaks down protein structure, causes severe damage and breakage.', 'critical', 'Only apply chemicals to new growth, use professional services, space treatments 10-12 weeks minimum.', 'Severe breakage, chemical burns, hair loss, permanent damage requiring big chop.'),
(12, 'Hot Water Washing', 'practice', 'Washing and rinsing hair with very hot water regularly.', 'Hot water opens cuticles but also strips oils, causes frizz, and can dry out hair and scalp.', 'low', 'Use lukewarm water for washing, finish with cool water rinse to seal cuticles.', 'Increased dryness, frizz, color fading, faster product buildup.'),
(13, 'Brushing Curly Hair Dry', 'practice', 'Using a brush on dry curly or coily hair.', 'Brushing dry curls causes frizz, breaks curl pattern, creates breakage, and can be painful.', 'medium', 'Only detangle wet hair with conditioner using fingers or wide-tooth comb. Use denman brush on wet hair only.', 'Broken curl pattern, frizz, breakage, damaged cuticle, loss of definition.'),
(14, 'Skipping Trims', 'practice', 'Avoiding haircuts for 6+ months allowing split ends to accumulate.', 'Split ends continue splitting up the hair shaft, causing more damage than the trim would remove.', 'medium', 'Trim every 8-12 weeks or as needed. Search and destroy method for minor splits.', 'Progressive damage up hair shaft, more dramatic trims needed, difficulty retaining length.'),
(15, 'Using Drying Alcohols', 'product', 'Products containing bad alcohols like SD alcohol, denatured alcohol in first 5 ingredients.', 'Drying alcohols strip moisture, cause dryness and brittleness, especially harmful for dry hair types.', 'medium', 'Choose products with fatty alcohols (cetyl, stearyl) or avoid alcohol in first ingredients.', 'Chronic dryness, frizz, breakage, difficulty maintaining moisture balance.'),
(1, 'Regular Elastic Bands', 'tool', 'Using regular rubber bands or tight elastics on hair instead of hair-safe alternatives.', 'Rubber bands snag and break hair, cause breakage at tension points, and can get tangled requiring cutting out.', 'high', 'Use satin scrunchies, spiral hair ties, or soft fabric-covered elastics that don\'t snag.', 'Persistent breakage, damaged hair shaft, possible bald spots at frequent tie locations.'),
(2, 'Daily Heat Styling', 'practice', 'Using flat irons, curling irons, or blow dryers with heat on hair every day.', 'Continuous high heat breaks down protein bonds, strips moisture, and permanently damages hair cuticle.', 'critical', 'Air dry when possible, use heatless styling methods, limit heat to once per week maximum with protectant.', 'Permanently altered texture, chronic dryness, severe breakage, split ends, loss of elasticity.'),
(3, 'Sulfate Shampoos', 'product', 'Regular use of shampoos containing harsh sulfates like SLS or SLES.', 'Sulfates are harsh detergents that strip natural oils, disrupt moisture balance, and cause dryness.', 'medium', 'Switch to sulfate-free shampoos, try co-washing, or use gentler cleansing options.', 'Chronic dryness, color fading, increased frizz, damaged cuticle layer.'),
(4, 'Skipping Heat Protectant', 'practice', 'Applying heat styling tools directly to hair without protective barrier.', 'Unprotected hair experiences direct protein damage, moisture loss, and cuticle destruction from heat.', 'high', 'Always apply heat protectant spray or serum before any heat styling, no exceptions.', 'Irreversible heat damage, brittle hair, severe breakage, permanently altered texture.'),
(5, 'Tight Protective Styles', 'styling', 'Installing braids, weaves, or ponytails with excessive tension on scalp and hairline.', 'Constant tension damages follicles, causes inflammation, and leads to traction alopecia.', 'critical', 'Ensure styles are comfortable, can move fingers under braids, no pain or tightness, no bumps on scalp.', 'Traction alopecia, permanent hair loss at edges and nape, damaged follicles, scarring.'),
(6, 'Sleeping on Cotton Pillowcases', 'practice', 'Using regular cotton pillowcases instead of satin or silk alternatives.', 'Cotton absorbs moisture from hair, creates friction causing breakage, and disturbs curl pattern.', 'medium', 'Use satin or silk pillowcases, or wear a satin bonnet or scarf to bed.', 'Chronic dryness, increased breakage, frizz, loss of curl definition over time.'),
(7, 'Over-Washing', 'practice', 'Washing hair daily or every other day, stripping natural oils.', 'Frequent washing removes sebum needed for protection and moisture, leading to dryness and breakage.', 'medium', 'Wash 1-2 times per week for most hair types, adjust based on activity level and scalp type.', 'Dry scalp, brittle hair, increased breakage, color fading, moisture imbalance.'),
(8, 'Skipping Deep Conditioning', 'practice', 'Only using regular conditioner without weekly deep conditioning treatments.', 'Regular conditioner provides surface moisture but doesn\'t penetrate for lasting hydration and repair.', 'high', 'Deep condition weekly for at least 20 minutes with heat for low porosity, 30+ minutes for high porosity.', 'Cumulative dryness, increased breakage, poor moisture retention, stunted length.'),
(9, 'Combing from Roots', 'practice', 'Starting detangling process at roots and pulling comb down through tangles.', 'Pulling from roots tears through knots, causes breakage, and creates more tangles.', 'high', 'Always detangle from ends working up to roots, use fingers first, then wide-tooth comb on wet hair with conditioner.', 'Excessive breakage, damaged cuticle, split ends, thinning throughout length.'),
(10, 'Protein Without Moisture', 'product', 'Using protein treatments frequently without balancing with moisture treatments.', 'Excess protein without moisture causes hair to become hard, brittle, and prone to snapping.', 'high', 'Always follow protein treatments with moisturizing deep conditioner. Balance is key - most need more moisture than protein.', 'Protein overload, brittle hair that snaps easily, loss of elasticity, severe breakage.'),
(11, 'Chemical Overlapping', 'chemical', 'Applying relaxer or color to previously processed hair, causing overlap.', 'Double processing the same hair section breaks down protein structure, causes severe damage and breakage.', 'critical', 'Only apply chemicals to new growth, use professional services, space treatments 10-12 weeks minimum.', 'Severe breakage, chemical burns, hair loss, permanent damage requiring big chop.'),
(12, 'Hot Water Washing', 'practice', 'Washing and rinsing hair with very hot water regularly.', 'Hot water opens cuticles but also strips oils, causes frizz, and can dry out hair and scalp.', 'low', 'Use lukewarm water for washing, finish with cool water rinse to seal cuticles.', 'Increased dryness, frizz, color fading, faster product buildup.'),
(13, 'Brushing Curly Hair Dry', 'practice', 'Using a brush on dry curly or coily hair.', 'Brushing dry curls causes frizz, breaks curl pattern, creates breakage, and can be painful.', 'medium', 'Only detangle wet hair with conditioner using fingers or wide-tooth comb. Use denman brush on wet hair only.', 'Broken curl pattern, frizz, breakage, damaged cuticle, loss of definition.'),
(14, 'Skipping Trims', 'practice', 'Avoiding haircuts for 6+ months allowing split ends to accumulate.', 'Split ends continue splitting up the hair shaft, causing more damage than the trim would remove.', 'medium', 'Trim every 8-12 weeks or as needed. Search and destroy method for minor splits.', 'Progressive damage up hair shaft, more dramatic trims needed, difficulty retaining length.'),
(15, 'Using Drying Alcohols', 'product', 'Products containing bad alcohols like SD alcohol, denatured alcohol in first 5 ingredients.', 'Drying alcohols strip moisture, cause dryness and brittleness, especially harmful for dry hair types.', 'medium', 'Choose products with fatty alcohols (cetyl, stearyl) or avoid alcohol in first ingredients.', 'Chronic dryness, frizz, breakage, difficulty maintaining moisture balance.'),
(1, 'Regular Elastic Bands', 'tool', 'Using regular rubber bands or tight elastics on hair instead of hair-safe alternatives.', 'Rubber bands snag and break hair, cause breakage at tension points, and can get tangled requiring cutting out.', 'high', 'Use satin scrunchies, spiral hair ties, or soft fabric-covered elastics that don\'t snag.', 'Persistent breakage, damaged hair shaft, possible bald spots at frequent tie locations.'),
(2, 'Daily Heat Styling', 'practice', 'Using flat irons, curling irons, or blow dryers with heat on hair every day.', 'Continuous high heat breaks down protein bonds, strips moisture, and permanently damages hair cuticle.', 'critical', 'Air dry when possible, use heatless styling methods, limit heat to once per week maximum with protectant.', 'Permanently altered texture, chronic dryness, severe breakage, split ends, loss of elasticity.'),
(3, 'Sulfate Shampoos', 'product', 'Regular use of shampoos containing harsh sulfates like SLS or SLES.', 'Sulfates are harsh detergents that strip natural oils, disrupt moisture balance, and cause dryness.', 'medium', 'Switch to sulfate-free shampoos, try co-washing, or use gentler cleansing options.', 'Chronic dryness, color fading, increased frizz, damaged cuticle layer.'),
(4, 'Skipping Heat Protectant', 'practice', 'Applying heat styling tools directly to hair without protective barrier.', 'Unprotected hair experiences direct protein damage, moisture loss, and cuticle destruction from heat.', 'high', 'Always apply heat protectant spray or serum before any heat styling, no exceptions.', 'Irreversible heat damage, brittle hair, severe breakage, permanently altered texture.'),
(5, 'Tight Protective Styles', 'styling', 'Installing braids, weaves, or ponytails with excessive tension on scalp and hairline.', 'Constant tension damages follicles, causes inflammation, and leads to traction alopecia.', 'critical', 'Ensure styles are comfortable, can move fingers under braids, no pain or tightness, no bumps on scalp.', 'Traction alopecia, permanent hair loss at edges and nape, damaged follicles, scarring.'),
(6, 'Sleeping on Cotton Pillowcases', 'practice', 'Using regular cotton pillowcases instead of satin or silk alternatives.', 'Cotton absorbs moisture from hair, creates friction causing breakage, and disturbs curl pattern.', 'medium', 'Use satin or silk pillowcases, or wear a satin bonnet or scarf to bed.', 'Chronic dryness, increased breakage, frizz, loss of curl definition over time.'),
(7, 'Over-Washing', 'practice', 'Washing hair daily or every other day, stripping natural oils.', 'Frequent washing removes sebum needed for protection and moisture, leading to dryness and breakage.', 'medium', 'Wash 1-2 times per week for most hair types, adjust based on activity level and scalp type.', 'Dry scalp, brittle hair, increased breakage, color fading, moisture imbalance.'),
(8, 'Skipping Deep Conditioning', 'practice', 'Only using regular conditioner without weekly deep conditioning treatments.', 'Regular conditioner provides surface moisture but doesn\'t penetrate for lasting hydration and repair.', 'high', 'Deep condition weekly for at least 20 minutes with heat for low porosity, 30+ minutes for high porosity.', 'Cumulative dryness, increased breakage, poor moisture retention, stunted length.'),
(9, 'Combing from Roots', 'practice', 'Starting detangling process at roots and pulling comb down through tangles.', 'Pulling from roots tears through knots, causes breakage, and creates more tangles.', 'high', 'Always detangle from ends working up to roots, use fingers first, then wide-tooth comb on wet hair with conditioner.', 'Excessive breakage, damaged cuticle, split ends, thinning throughout length.'),
(10, 'Protein Without Moisture', 'product', 'Using protein treatments frequently without balancing with moisture treatments.', 'Excess protein without moisture causes hair to become hard, brittle, and prone to snapping.', 'high', 'Always follow protein treatments with moisturizing deep conditioner. Balance is key - most need more moisture than protein.', 'Protein overload, brittle hair that snaps easily, loss of elasticity, severe breakage.'),
(11, 'Chemical Overlapping', 'chemical', 'Applying relaxer or color to previously processed hair, causing overlap.', 'Double processing the same hair section breaks down protein structure, causes severe damage and breakage.', 'critical', 'Only apply chemicals to new growth, use professional services, space treatments 10-12 weeks minimum.', 'Severe breakage, chemical burns, hair loss, permanent damage requiring big chop.'),
(12, 'Hot Water Washing', 'practice', 'Washing and rinsing hair with very hot water regularly.', 'Hot water opens cuticles but also strips oils, causes frizz, and can dry out hair and scalp.', 'low', 'Use lukewarm water for washing, finish with cool water rinse to seal cuticles.', 'Increased dryness, frizz, color fading, faster product buildup.'),
(13, 'Brushing Curly Hair Dry', 'practice', 'Using a brush on dry curly or coily hair.', 'Brushing dry curls causes frizz, breaks curl pattern, creates breakage, and can be painful.', 'medium', 'Only detangle wet hair with conditioner using fingers or wide-tooth comb. Use denman brush on wet hair only.', 'Broken curl pattern, frizz, breakage, damaged cuticle, loss of definition.'),
(14, 'Skipping Trims', 'practice', 'Avoiding haircuts for 6+ months allowing split ends to accumulate.', 'Split ends continue splitting up the hair shaft, causing more damage than the trim would remove.', 'medium', 'Trim every 8-12 weeks or as needed. Search and destroy method for minor splits.', 'Progressive damage up hair shaft, more dramatic trims needed, difficulty retaining length.'),
(15, 'Using Drying Alcohols', 'product', 'Products containing bad alcohols like SD alcohol, denatured alcohol in first 5 ingredients.', 'Drying alcohols strip moisture, cause dryness and brittleness, especially harmful for dry hair types.', 'medium', 'Choose products with fatty alcohols (cetyl, stearyl) or avoid alcohol in first ingredients.', 'Chronic dryness, frizz, breakage, difficulty maintaining moisture balance.');

-- --------------------------------------------------------

--
-- Table structure for table `hair_symptoms`
--

CREATE TABLE `hair_symptoms` (
  `symptom_id` int NOT NULL,
  `symptom_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `category` enum('breakage','dryness','dandruff','shedding','scalp_irritation','thinning','split_ends','lack_of_growth','texture_change','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `severity_indicators` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `hair_symptoms`
--

INSERT INTO `hair_symptoms` (`symptom_id`, `symptom_name`, `category`, `description`, `severity_indicators`) VALUES
(1, 'Hair Breakage at Mid-Shaft', 'breakage', 'Hair strands snapping in the middle rather than at ends, creating uneven lengths.', 'Mild: Few broken hairs. Moderate: Noticeable breakage during styling. Severe: Constant breakage, significant length loss'),
(2, 'Excessive Dryness', 'dryness', 'Hair feels rough, straw-like, and lacks moisture no matter what products are used.', 'Mild: Dry to touch. Moderate: Very rough texture, difficult to moisturize. Severe: Extremely brittle, breaks easily'),
(3, 'White Flaky Scalp', 'dandruff', 'White or grayish flakes on scalp and shoulders, may or may not itch.', 'Mild: Few flakes occasionally. Moderate: Regular flaking, some itching. Severe: Large flakes, constant shedding, itching'),
(4, 'Yellow Oily Flakes', 'dandruff', 'Yellow, greasy flakes that stick to hair and scalp, often with redness.', 'Mild: Slight yellowing. Moderate: Visible oily flakes, some redness. Severe: Thick scales, inflammation, odor'),
(5, 'Excessive Hair in Drain', 'shedding', 'Noticing more hair than usual coming out during washing or styling.', 'Mild: Slightly more than normal. Moderate: Clumps in drain. Severe: Handfuls coming out, visible thinning'),
(6, 'Hair in Brush/Comb', 'shedding', 'Large amounts of hair collecting in combs and brushes with each use.', 'Mild: More than usual but manageable. Moderate: Brush fills quickly. Severe: Excessive amounts, visible loss'),
(7, 'Itchy Scalp', 'scalp_irritation', 'Persistent itching sensation on scalp requiring frequent scratching.', 'Mild: Occasional itch. Moderate: Frequent itching, discomfort. Severe: Constant itching, affecting daily life'),
(8, 'Burning Sensation', 'scalp_irritation', 'Burning, stinging, or hot feeling on scalp, especially after products.', 'Mild: Slight warmth. Moderate: Uncomfortable burning. Severe: Painful, may prevent product use'),
(9, 'Scalp Redness', 'scalp_irritation', 'Visible redness or inflammation on scalp, may be patchy or widespread.', 'Mild: Slight pink areas. Moderate: Noticeably red patches. Severe: Deep redness, swelling, pain'),
(10, 'Tender Scalp', 'scalp_irritation', 'Scalp feels sore or painful to touch, especially at roots.', 'Mild: Slight tenderness. Moderate: Painful when touched. Severe: Hurts constantly, even without touch'),
(11, 'Visible Scalp Through Hair', 'thinning', 'Can see scalp clearly through hair, especially at part or crown.', 'Mild: Slightly wider part. Moderate: Clear scalp visibility. Severe: Large areas of visible scalp'),
(12, 'Receding Hairline', 'thinning', 'Hairline moving backward, particularly at temples or forehead.', 'Mild: Slight recession. Moderate: Noticeable change. Severe: Significant recession, possible balding'),
(13, 'Thinning at Crown', 'thinning', 'Hair becoming noticeably thinner at the top/back of head.', 'Mild: Slightly less dense. Moderate: Clear thinning visible. Severe: Nearly bald spot'),
(14, 'Split Ends', 'split_ends', 'Hair shaft splitting into two or more parts at the ends.', 'Mild: Few splits on inspection. Moderate: Many visible splits. Severe: Splits traveling up shaft'),
(15, 'Single Strand Knots', 'split_ends', 'Individual hair strands tying themselves into knots, common in coily hair.', 'Mild: Occasional knots. Moderate: Frequent knots. Severe: Numerous knots causing tangles'),
(16, 'No Length Progress', 'lack_of_growth', 'Hair appears stuck at same length for extended period despite time passing.', 'Mild: Slow progress. Moderate: No change in 6 months. Severe: No change in 12+ months'),
(17, 'Hair Growing Very Slowly', 'lack_of_growth', 'Hair growing at rate noticeably slower than average 0.5 inches per month.', 'Mild: Slightly slower. Moderate: Significantly slower. Severe: Almost no visible growth'),
(18, 'Loss of Curl Pattern', 'texture_change', 'Curls becoming looser, straighter, or losing definition.', 'Mild: Slight loosening. Moderate: Noticeable pattern change. Severe: Complete loss of curl'),
(19, 'Hair Becoming More Brittle', 'texture_change', 'Hair feeling increasingly fragile, dry, or straw-like over time.', 'Mild: Slightly less flexible. Moderate: Noticeably brittle. Severe: Extremely fragile, breaks easily'),
(20, 'Lack of Shine/Dullness', 'other', 'Hair appearing dull, lackluster, without healthy shine or glow.', 'Mild: Less shiny than before. Moderate: Consistently dull. Severe: Extremely matte, unhealthy appearance');

-- --------------------------------------------------------

--
-- Table structure for table `hair_types`
--

CREATE TABLE `hair_types` (
  `hair_type_id` int NOT NULL,
  `type_code` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `type_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `category` enum('straight','wavy','curly','coily') COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `characteristics` text COLLATE utf8mb4_general_ci,
  `care_tips` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hair_types`
--

INSERT INTO `hair_types` (`hair_type_id`, `type_code`, `type_name`, `category`, `description`, `characteristics`, `care_tips`) VALUES
(1, '1A', 'Type 1A - Straight Fine', 'straight', 'Straight, fine hair with no curl pattern', 'Very fine, soft, and silky', 'Use lightweight products, avoid heavy oils, add volume with root lifters, wash frequently if needed'),
(2, '1B', 'Type 1B - Straight Medium', 'straight', 'Straight, medium-textured hair', 'Slightly thicker than 1A, still straight', 'Balance moisture without weighing down, use volumizing products, limit heavy conditioners on roots'),
(3, '1C', 'Type 1C - Straight Coarse', 'straight', 'Straight, coarse hair', 'Thick and coarse, resistant to curling', 'Use smoothing products, deep condition regularly, may need stronger hold products for styling'),
(4, '2A', 'Type 2A - Wavy Fine', 'wavy', 'Fine, wavy hair with loose S-shaped waves', 'Gentle waves, easy to style', 'Use lightweight mousses, avoid heavy products, scrunch to enhance waves, air dry when possible'),
(5, '2B', 'Type 2B - Wavy Medium', 'wavy', 'Medium-textured wavy hair', 'More defined waves than 2A', 'Use curl creams, diffuse or air dry, scrunch with gel, avoid brushing when dry'),
(6, '2C', 'Type 2C - Wavy Coarse', 'wavy', 'Coarse, wavy hair with defined waves', 'Thick waves, can be frizzy', 'Use curl defining products, deep condition weekly, use gel for hold, protect at night'),
(7, '3A', 'Type 3A - Curly Loose', 'curly', 'Loose, springy curls', 'Large, defined curls', 'Use leave-in conditioners, curl creams, avoid sulfates, refresh with water spray, protect curls at night'),
(8, '3B', 'Type 3B - Curly Medium', 'curly', 'Medium, bouncy curls', 'Tight, springy ringlets', 'Deep condition weekly, use curl custards, avoid heat, detangle with conditioner, use satin pillowcase'),
(9, '3C', 'Type 3C - Curly Tight', 'curly', 'Tight, corkscrew curls', 'Small, tight curls', 'Moisture is key, use LOC method, deep condition frequently, minimal manipulation, protective styles'),
(10, '4A', 'Type 4A - Coily Soft', 'coily', 'Soft, tightly coiled hair', 'Defined S-pattern coils', 'Keep moisturized, use creams and butters, detangle gently, protect ends, avoid heat'),
(11, '4B', 'Type 4B - Coily Zigzag', 'coily', 'Zigzag pattern coils', 'Less defined, more cotton-like', 'Maximum moisture, seal with heavy oils/butters, gentle handling, protective styles, avoid manipulation'),
(12, '4C', 'Type 4C - Coily Tight', 'coily', 'Tightly coiled, very fragile', 'Tightest curl pattern, most fragile', 'Keep well-moisturized, use heavy sealants, low manipulation, protective styles, be very gentle');

-- --------------------------------------------------------

--
-- Table structure for table `method_age_suitability`
--

CREATE TABLE `method_age_suitability` (
  `suitability_id` int NOT NULL,
  `method_id` int NOT NULL,
  `age_group` enum('child','teen','young_adult','adult','middle_aged','senior') COLLATE utf8mb4_general_ci NOT NULL,
  `suitability_score` int DEFAULT NULL,
  `age_modifications` text COLLATE utf8mb4_general_ci,
  `precautions` text COLLATE utf8mb4_general_ci
) ;

--
-- Dumping data for table `method_age_suitability`
--

INSERT INTO `method_age_suitability` (`suitability_id`, `method_id`, `age_group`, `suitability_score`, `age_modifications`, `precautions`) VALUES
(1, 1, 'child', 10, 'Use very gentle pressure, make it fun and relaxing', 'Always gentle, never forceful'),
(2, 1, 'teen', 10, 'Can increase pressure slightly, good stress relief', 'Teach proper technique'),
(3, 1, 'young_adult', 10, 'Standard technique works well', 'Consistency is key'),
(4, 1, 'adult', 10, 'Excellent for stress relief and growth', 'Can use oils for added benefit'),
(5, 1, 'middle_aged', 10, 'Critical for maintaining growth, increase frequency', 'Very gentle on thinning areas'),
(6, 1, 'senior', 10, 'Essential for scalp health, use gentle pressure', 'Be extremely gentle, scalp is more sensitive'),
(7, 2, 'child', 7, 'Only very loose styles, frequent breaks needed', 'NEVER tight styles - developing follicles are fragile'),
(8, 2, 'teen', 9, 'Good option but teach proper tension', 'Monitor for traction, educate on risks'),
(9, 2, 'young_adult', 10, 'Excellent option for retention', 'Ensure proper installation'),
(10, 2, 'adult', 10, 'Great for busy lifestyle', 'Watch hairline and edges'),
(11, 2, 'middle_aged', 9, 'Good but needs gentler approach', 'Shorter duration, no tension on thinning areas'),
(12, 2, 'senior', 7, 'Use with caution, lighter styles only', 'Avoid weight and tension, hair is fragile'),
(13, 3, 'child', 8, 'Gentle, moisture-based only, no protein', 'Avoid heat, shorter duration'),
(14, 3, 'teen', 10, 'Excellent habit to establish', 'Adjust based on activity level'),
(15, 3, 'young_adult', 10, 'Essential for maintaining health', 'Balance protein and moisture'),
(16, 3, 'adult', 10, 'Increase frequency as needed', 'Add heat for better penetration'),
(17, 3, 'middle_aged', 10, 'Critical for combating dryness', '2x weekly recommended'),
(18, 3, 'senior', 10, 'Non-negotiable for hair health', 'Focus on moisture, gentle heat'),
(1, 1, 'child', 10, 'Use very gentle pressure, make it fun and relaxing', 'Always gentle, never forceful'),
(2, 1, 'teen', 10, 'Can increase pressure slightly, good stress relief', 'Teach proper technique'),
(3, 1, 'young_adult', 10, 'Standard technique works well', 'Consistency is key'),
(4, 1, 'adult', 10, 'Excellent for stress relief and growth', 'Can use oils for added benefit'),
(5, 1, 'middle_aged', 10, 'Critical for maintaining growth, increase frequency', 'Very gentle on thinning areas'),
(6, 1, 'senior', 10, 'Essential for scalp health, use gentle pressure', 'Be extremely gentle, scalp is more sensitive'),
(7, 2, 'child', 7, 'Only very loose styles, frequent breaks needed', 'NEVER tight styles - developing follicles are fragile'),
(8, 2, 'teen', 9, 'Good option but teach proper tension', 'Monitor for traction, educate on risks'),
(9, 2, 'young_adult', 10, 'Excellent option for retention', 'Ensure proper installation'),
(10, 2, 'adult', 10, 'Great for busy lifestyle', 'Watch hairline and edges'),
(11, 2, 'middle_aged', 9, 'Good but needs gentler approach', 'Shorter duration, no tension on thinning areas'),
(12, 2, 'senior', 7, 'Use with caution, lighter styles only', 'Avoid weight and tension, hair is fragile'),
(13, 3, 'child', 8, 'Gentle, moisture-based only, no protein', 'Avoid heat, shorter duration'),
(14, 3, 'teen', 10, 'Excellent habit to establish', 'Adjust based on activity level'),
(15, 3, 'young_adult', 10, 'Essential for maintaining health', 'Balance protein and moisture'),
(16, 3, 'adult', 10, 'Increase frequency as needed', 'Add heat for better penetration'),
(17, 3, 'middle_aged', 10, 'Critical for combating dryness', '2x weekly recommended'),
(18, 3, 'senior', 10, 'Non-negotiable for hair health', 'Focus on moisture, gentle heat'),
(1, 1, 'child', 10, 'Use very gentle pressure, make it fun and relaxing', 'Always gentle, never forceful'),
(2, 1, 'teen', 10, 'Can increase pressure slightly, good stress relief', 'Teach proper technique'),
(3, 1, 'young_adult', 10, 'Standard technique works well', 'Consistency is key'),
(4, 1, 'adult', 10, 'Excellent for stress relief and growth', 'Can use oils for added benefit'),
(5, 1, 'middle_aged', 10, 'Critical for maintaining growth, increase frequency', 'Very gentle on thinning areas'),
(6, 1, 'senior', 10, 'Essential for scalp health, use gentle pressure', 'Be extremely gentle, scalp is more sensitive'),
(7, 2, 'child', 7, 'Only very loose styles, frequent breaks needed', 'NEVER tight styles - developing follicles are fragile'),
(8, 2, 'teen', 9, 'Good option but teach proper tension', 'Monitor for traction, educate on risks'),
(9, 2, 'young_adult', 10, 'Excellent option for retention', 'Ensure proper installation'),
(10, 2, 'adult', 10, 'Great for busy lifestyle', 'Watch hairline and edges'),
(11, 2, 'middle_aged', 9, 'Good but needs gentler approach', 'Shorter duration, no tension on thinning areas'),
(12, 2, 'senior', 7, 'Use with caution, lighter styles only', 'Avoid weight and tension, hair is fragile'),
(13, 3, 'child', 8, 'Gentle, moisture-based only, no protein', 'Avoid heat, shorter duration'),
(14, 3, 'teen', 10, 'Excellent habit to establish', 'Adjust based on activity level'),
(15, 3, 'young_adult', 10, 'Essential for maintaining health', 'Balance protein and moisture'),
(16, 3, 'adult', 10, 'Increase frequency as needed', 'Add heat for better penetration'),
(17, 3, 'middle_aged', 10, 'Critical for combating dryness', '2x weekly recommended'),
(18, 3, 'senior', 10, 'Non-negotiable for hair health', 'Focus on moisture, gentle heat');

-- --------------------------------------------------------

--
-- Table structure for table `method_hair_type_compatibility`
--

CREATE TABLE `method_hair_type_compatibility` (
  `compatibility_id` int NOT NULL,
  `method_id` int NOT NULL,
  `hair_type_id` int NOT NULL,
  `effectiveness_score` int DEFAULT NULL,
  `notes` text COLLATE utf8mb4_general_ci
) ;

--
-- Dumping data for table `method_hair_type_compatibility`
--

INSERT INTO `method_hair_type_compatibility` (`compatibility_id`, `method_id`, `hair_type_id`, `effectiveness_score`, `notes`) VALUES
(1, 1, 7, 8, 'Works well for 3A, use lighter oils'),
(2, 1, 8, 9, 'Very effective for 3B'),
(3, 1, 9, 9, 'Excellent for 3C curls'),
(4, 1, 10, 10, 'Perfect for 4A hair, highly recommended'),
(5, 1, 11, 10, 'Ideal for 4B, crucial for moisture'),
(6, 1, 12, 10, 'Essential for 4C, use heavier oils'),
(7, 2, 1, 10, 'Beneficial for all types including 1A'),
(8, 2, 7, 10, 'Excellent for 3A'),
(9, 2, 8, 10, 'Great for 3B'),
(10, 2, 9, 10, 'Works well for 3C'),
(11, 2, 10, 10, 'Highly effective for 4A'),
(12, 2, 11, 10, 'Great for 4B'),
(13, 2, 12, 10, 'Very important for 4C growth'),
(14, 3, 7, 10, 'Essential for 3A curls'),
(15, 3, 8, 10, 'Crucial for 3B maintenance'),
(16, 3, 9, 10, 'Vital for 3C health'),
(17, 3, 10, 10, 'Absolutely necessary for 4A'),
(18, 3, 11, 10, 'Critical for 4B moisture'),
(19, 3, 12, 10, 'Non-negotiable for 4C hair'),
(20, 5, 7, 7, 'Helpful for 3A but not always needed'),
(21, 5, 8, 8, 'Good for 3B length retention'),
(22, 5, 9, 9, 'Very beneficial for 3C'),
(23, 5, 10, 10, 'Excellent for 4A hair'),
(24, 5, 11, 10, 'Highly recommended for 4B'),
(25, 5, 12, 10, 'Essential for 4C length retention'),
(32, 1, 1, 8, 'Beneficial for all types including 1A'),
(33, 1, 2, 8, 'Great for 1B stimulation'),
(34, 1, 3, 8, 'Excellent for 1C'),
(35, 1, 4, 9, 'Very effective for 2A'),
(36, 1, 5, 9, 'Great for 2B'),
(37, 1, 6, 9, 'Excellent for 2C'),
(38, 2, 2, 8, 'Good for 1B with proper technique'),
(39, 2, 3, 9, 'Very beneficial for 1C'),
(40, 2, 4, 9, 'Excellent for 2A'),
(41, 2, 5, 9, 'Great for 2B'),
(42, 2, 6, 10, 'Perfect for 2C'),
(43, 3, 1, 8, 'Important for 1A moisture'),
(44, 3, 2, 9, 'Essential for 1B'),
(45, 3, 3, 9, 'Crucial for 1C'),
(46, 3, 4, 9, 'Very important for 2A'),
(47, 3, 5, 10, 'Essential for 2B'),
(48, 3, 6, 10, 'Critical for 2C'),
(49, 4, 1, 7, 'Helpful for 1A'),
(50, 4, 2, 8, 'Good for 1B'),
(51, 4, 3, 8, 'Beneficial for 1C'),
(52, 4, 4, 8, 'Important for 2A'),
(53, 4, 5, 9, 'Very helpful for 2B'),
(54, 4, 6, 9, 'Excellent for 2C'),
(55, 4, 7, 9, 'Great for 3A'),
(56, 4, 8, 9, 'Very important for 3B'),
(57, 4, 9, 10, 'Essential for 3C'),
(58, 4, 10, 10, 'Critical for 4A'),
(59, 4, 11, 10, 'Vital for 4B'),
(60, 4, 12, 10, 'Absolutely necessary for 4C'),
(61, 5, 1, 8, 'Important for 1A health'),
(62, 5, 2, 8, 'Good for 1B maintenance'),
(63, 5, 3, 8, 'Beneficial for 1C'),
(64, 5, 4, 8, 'Helpful for 2A'),
(65, 5, 5, 9, 'Very good for 2B'),
(66, 5, 6, 9, 'Excellent for 2C'),
(67, 6, 1, 6, 'Use lightly for 1A'),
(68, 6, 2, 7, 'Moderate use for 1B'),
(69, 6, 3, 8, 'Good for 1C'),
(70, 6, 4, 7, 'Beneficial for 2A'),
(71, 6, 5, 8, 'Great for 2B'),
(72, 6, 6, 9, 'Excellent for 2C'),
(73, 6, 7, 9, 'Very good for 3A'),
(74, 6, 8, 9, 'Great for 3B'),
(75, 6, 9, 10, 'Perfect for 3C'),
(76, 6, 10, 10, 'Ideal for 4A'),
(77, 6, 11, 10, 'Excellent for 4B'),
(78, 6, 12, 10, 'Best for 4C'),
(1, 1, 7, 8, 'Works well for 3A, use lighter oils'),
(2, 1, 8, 9, 'Very effective for 3B'),
(3, 1, 9, 9, 'Excellent for 3C curls'),
(4, 1, 10, 10, 'Perfect for 4A hair, highly recommended'),
(5, 1, 11, 10, 'Ideal for 4B, crucial for moisture'),
(6, 1, 12, 10, 'Essential for 4C, use heavier oils'),
(7, 2, 1, 10, 'Beneficial for all types including 1A'),
(8, 2, 7, 10, 'Excellent for 3A'),
(9, 2, 8, 10, 'Great for 3B'),
(10, 2, 9, 10, 'Works well for 3C'),
(11, 2, 10, 10, 'Highly effective for 4A'),
(12, 2, 11, 10, 'Great for 4B'),
(13, 2, 12, 10, 'Very important for 4C growth'),
(14, 3, 7, 10, 'Essential for 3A curls'),
(15, 3, 8, 10, 'Crucial for 3B maintenance'),
(16, 3, 9, 10, 'Vital for 3C health'),
(17, 3, 10, 10, 'Absolutely necessary for 4A'),
(18, 3, 11, 10, 'Critical for 4B moisture'),
(19, 3, 12, 10, 'Non-negotiable for 4C hair'),
(20, 5, 7, 7, 'Helpful for 3A but not always needed'),
(21, 5, 8, 8, 'Good for 3B length retention'),
(22, 5, 9, 9, 'Very beneficial for 3C'),
(23, 5, 10, 10, 'Excellent for 4A hair'),
(24, 5, 11, 10, 'Highly recommended for 4B'),
(25, 5, 12, 10, 'Essential for 4C length retention'),
(32, 1, 1, 8, 'Beneficial for all types including 1A'),
(33, 1, 2, 8, 'Great for 1B stimulation'),
(34, 1, 3, 8, 'Excellent for 1C'),
(35, 1, 4, 9, 'Very effective for 2A'),
(36, 1, 5, 9, 'Great for 2B'),
(37, 1, 6, 9, 'Excellent for 2C'),
(38, 2, 2, 8, 'Good for 1B with proper technique'),
(39, 2, 3, 9, 'Very beneficial for 1C'),
(40, 2, 4, 9, 'Excellent for 2A'),
(41, 2, 5, 9, 'Great for 2B'),
(42, 2, 6, 10, 'Perfect for 2C'),
(43, 3, 1, 8, 'Important for 1A moisture'),
(44, 3, 2, 9, 'Essential for 1B'),
(45, 3, 3, 9, 'Crucial for 1C'),
(46, 3, 4, 9, 'Very important for 2A'),
(47, 3, 5, 10, 'Essential for 2B'),
(48, 3, 6, 10, 'Critical for 2C'),
(49, 4, 1, 7, 'Helpful for 1A'),
(50, 4, 2, 8, 'Good for 1B'),
(51, 4, 3, 8, 'Beneficial for 1C'),
(52, 4, 4, 8, 'Important for 2A'),
(53, 4, 5, 9, 'Very helpful for 2B'),
(54, 4, 6, 9, 'Excellent for 2C'),
(55, 4, 7, 9, 'Great for 3A'),
(56, 4, 8, 9, 'Very important for 3B'),
(57, 4, 9, 10, 'Essential for 3C'),
(58, 4, 10, 10, 'Critical for 4A'),
(59, 4, 11, 10, 'Vital for 4B'),
(60, 4, 12, 10, 'Absolutely necessary for 4C'),
(61, 5, 1, 8, 'Important for 1A health'),
(62, 5, 2, 8, 'Good for 1B maintenance'),
(63, 5, 3, 8, 'Beneficial for 1C'),
(64, 5, 4, 8, 'Helpful for 2A'),
(65, 5, 5, 9, 'Very good for 2B'),
(66, 5, 6, 9, 'Excellent for 2C'),
(67, 6, 1, 6, 'Use lightly for 1A'),
(68, 6, 2, 7, 'Moderate use for 1B'),
(69, 6, 3, 8, 'Good for 1C'),
(70, 6, 4, 7, 'Beneficial for 2A'),
(71, 6, 5, 8, 'Great for 2B'),
(72, 6, 6, 9, 'Excellent for 2C'),
(73, 6, 7, 9, 'Very good for 3A'),
(74, 6, 8, 9, 'Great for 3B'),
(75, 6, 9, 10, 'Perfect for 3C'),
(76, 6, 10, 10, 'Ideal for 4A'),
(77, 6, 11, 10, 'Excellent for 4B'),
(78, 6, 12, 10, 'Best for 4C'),
(1, 1, 7, 8, 'Works well for 3A, use lighter oils'),
(2, 1, 8, 9, 'Very effective for 3B'),
(3, 1, 9, 9, 'Excellent for 3C curls'),
(4, 1, 10, 10, 'Perfect for 4A hair, highly recommended'),
(5, 1, 11, 10, 'Ideal for 4B, crucial for moisture'),
(6, 1, 12, 10, 'Essential for 4C, use heavier oils'),
(7, 2, 1, 10, 'Beneficial for all types including 1A'),
(8, 2, 7, 10, 'Excellent for 3A'),
(9, 2, 8, 10, 'Great for 3B'),
(10, 2, 9, 10, 'Works well for 3C'),
(11, 2, 10, 10, 'Highly effective for 4A'),
(12, 2, 11, 10, 'Great for 4B'),
(13, 2, 12, 10, 'Very important for 4C growth'),
(14, 3, 7, 10, 'Essential for 3A curls'),
(15, 3, 8, 10, 'Crucial for 3B maintenance'),
(16, 3, 9, 10, 'Vital for 3C health'),
(17, 3, 10, 10, 'Absolutely necessary for 4A'),
(18, 3, 11, 10, 'Critical for 4B moisture'),
(19, 3, 12, 10, 'Non-negotiable for 4C hair'),
(20, 5, 7, 7, 'Helpful for 3A but not always needed'),
(21, 5, 8, 8, 'Good for 3B length retention'),
(22, 5, 9, 9, 'Very beneficial for 3C'),
(23, 5, 10, 10, 'Excellent for 4A hair'),
(24, 5, 11, 10, 'Highly recommended for 4B'),
(25, 5, 12, 10, 'Essential for 4C length retention'),
(32, 1, 1, 8, 'Beneficial for all types including 1A'),
(33, 1, 2, 8, 'Great for 1B stimulation'),
(34, 1, 3, 8, 'Excellent for 1C'),
(35, 1, 4, 9, 'Very effective for 2A'),
(36, 1, 5, 9, 'Great for 2B'),
(37, 1, 6, 9, 'Excellent for 2C'),
(38, 2, 2, 8, 'Good for 1B with proper technique'),
(39, 2, 3, 9, 'Very beneficial for 1C'),
(40, 2, 4, 9, 'Excellent for 2A'),
(41, 2, 5, 9, 'Great for 2B'),
(42, 2, 6, 10, 'Perfect for 2C'),
(43, 3, 1, 8, 'Important for 1A moisture'),
(44, 3, 2, 9, 'Essential for 1B'),
(45, 3, 3, 9, 'Crucial for 1C'),
(46, 3, 4, 9, 'Very important for 2A'),
(47, 3, 5, 10, 'Essential for 2B'),
(48, 3, 6, 10, 'Critical for 2C'),
(49, 4, 1, 7, 'Helpful for 1A'),
(50, 4, 2, 8, 'Good for 1B'),
(51, 4, 3, 8, 'Beneficial for 1C'),
(52, 4, 4, 8, 'Important for 2A'),
(53, 4, 5, 9, 'Very helpful for 2B'),
(54, 4, 6, 9, 'Excellent for 2C'),
(55, 4, 7, 9, 'Great for 3A'),
(56, 4, 8, 9, 'Very important for 3B'),
(57, 4, 9, 10, 'Essential for 3C'),
(58, 4, 10, 10, 'Critical for 4A'),
(59, 4, 11, 10, 'Vital for 4B'),
(60, 4, 12, 10, 'Absolutely necessary for 4C'),
(61, 5, 1, 8, 'Important for 1A health'),
(62, 5, 2, 8, 'Good for 1B maintenance'),
(63, 5, 3, 8, 'Beneficial for 1C'),
(64, 5, 4, 8, 'Helpful for 2A'),
(65, 5, 5, 9, 'Very good for 2B'),
(66, 5, 6, 9, 'Excellent for 2C'),
(67, 6, 1, 6, 'Use lightly for 1A'),
(68, 6, 2, 7, 'Moderate use for 1B'),
(69, 6, 3, 8, 'Good for 1C'),
(70, 6, 4, 7, 'Beneficial for 2A'),
(71, 6, 5, 8, 'Great for 2B'),
(72, 6, 6, 9, 'Excellent for 2C'),
(73, 6, 7, 9, 'Very good for 3A'),
(74, 6, 8, 9, 'Great for 3B'),
(75, 6, 9, 10, 'Perfect for 3C'),
(76, 6, 10, 10, 'Ideal for 4A'),
(77, 6, 11, 10, 'Excellent for 4B'),
(78, 6, 12, 10, 'Best for 4C');

-- --------------------------------------------------------

--
-- Table structure for table `parent_child_activity_log`
--

CREATE TABLE `parent_child_activity_log` (
  `log_id` int NOT NULL,
  `parent_user_id` int NOT NULL,
  `child_user_id` int NOT NULL,
  `action_type` enum('created','viewed_profile','edited_profile','viewed_progress','viewed_recommendations','deleted') COLLATE utf8mb4_general_ci NOT NULL,
  `action_details` text COLLATE utf8mb4_general_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `parent_child_activity_log`
--

INSERT INTO `parent_child_activity_log` (`log_id`, `parent_user_id`, `child_user_id`, `action_type`, `action_details`, `created_at`) VALUES
(1, 4, 6, 'created', 'Created child account for Adrian', '2025-12-12 23:23:44'),
(2, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:34:34'),
(3, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:34:51'),
(4, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:34:51'),
(5, 4, 6, 'edited_profile', 'Parent updated child hair profile', '2025-12-12 23:34:51'),
(6, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:34:52'),
(7, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:34:58'),
(8, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:34:58'),
(9, 4, 6, 'edited_profile', 'Parent updated child profile', '2025-12-12 23:34:58'),
(10, 4, 6, 'edited_profile', 'Parent updated child hair profile', '2025-12-12 23:34:58'),
(11, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:35:00'),
(12, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:35:05'),
(13, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:35:25'),
(14, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:35:28'),
(15, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:35:28'),
(16, 4, 6, 'edited_profile', 'Parent updated child profile', '2025-12-12 23:35:28'),
(17, 4, 6, 'edited_profile', 'Parent updated child hair profile', '2025-12-12 23:35:28'),
(18, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:35:30'),
(19, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:35:38'),
(20, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:35:38'),
(21, 4, 6, 'edited_profile', 'Parent updated child profile', '2025-12-12 23:35:38'),
(22, 4, 6, 'edited_profile', 'Parent updated child hair profile', '2025-12-12 23:35:38'),
(23, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:35:39'),
(24, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:38:30'),
(25, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:38:30'),
(26, 4, 6, 'edited_profile', 'Parent updated child profile', '2025-12-12 23:38:30'),
(27, 4, 6, 'edited_profile', 'Parent updated child hair profile', '2025-12-12 23:38:30'),
(28, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:38:31'),
(1, 4, 6, 'created', 'Created child account for Adrian', '2025-12-12 23:23:44'),
(2, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:34:34'),
(3, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:34:51'),
(4, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:34:51'),
(5, 4, 6, 'edited_profile', 'Parent updated child hair profile', '2025-12-12 23:34:51'),
(6, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:34:52'),
(7, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:34:58'),
(8, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:34:58'),
(9, 4, 6, 'edited_profile', 'Parent updated child profile', '2025-12-12 23:34:58'),
(10, 4, 6, 'edited_profile', 'Parent updated child hair profile', '2025-12-12 23:34:58'),
(11, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:35:00'),
(12, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:35:05'),
(13, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:35:25'),
(14, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:35:28'),
(15, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:35:28'),
(16, 4, 6, 'edited_profile', 'Parent updated child profile', '2025-12-12 23:35:28'),
(17, 4, 6, 'edited_profile', 'Parent updated child hair profile', '2025-12-12 23:35:28'),
(18, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:35:30'),
(19, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:35:38'),
(20, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:35:38'),
(21, 4, 6, 'edited_profile', 'Parent updated child profile', '2025-12-12 23:35:38'),
(22, 4, 6, 'edited_profile', 'Parent updated child hair profile', '2025-12-12 23:35:38'),
(23, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:35:39'),
(24, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:38:30'),
(25, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:38:30'),
(26, 4, 6, 'edited_profile', 'Parent updated child profile', '2025-12-12 23:38:30'),
(27, 4, 6, 'edited_profile', 'Parent updated child hair profile', '2025-12-12 23:38:30'),
(28, 4, 6, 'viewed_profile', 'Parent viewed child profile', '2025-12-12 23:38:31'),
(29, 7, 9, 'viewed_profile', 'Parent viewed child profile', '2025-12-13 22:30:25'),
(30, 7, 9, 'viewed_profile', 'Parent viewed child profile', '2025-12-13 22:30:34'),
(31, 7, 9, 'viewed_profile', 'Parent viewed child profile', '2025-12-13 22:30:34'),
(32, 7, 9, 'edited_profile', 'Parent updated child hair profile', '2025-12-13 22:30:34'),
(33, 7, 9, 'viewed_profile', 'Parent viewed child profile', '2025-12-13 22:30:35'),
(34, 7, 8, 'viewed_profile', 'Parent viewed child profile', '2025-12-13 22:30:56'),
(35, 7, 8, 'viewed_profile', 'Parent viewed child profile', '2025-12-13 22:31:05'),
(36, 7, 8, 'viewed_profile', 'Parent viewed child profile', '2025-12-13 22:31:05'),
(37, 7, 8, 'edited_profile', 'Parent updated child hair profile', '2025-12-13 22:31:05'),
(38, 7, 8, 'viewed_profile', 'Parent viewed child profile', '2025-12-13 22:31:06'),
(39, 7, 9, 'viewed_profile', 'Parent viewed child profile', '2025-12-13 23:01:32'),
(40, 10, 11, 'created', 'Created child account for James', '2025-12-13 23:19:00'),
(41, 10, 11, 'viewed_profile', 'Parent viewed child profile', '2025-12-13 23:19:03'),
(42, 10, 11, 'viewed_profile', 'Parent viewed child profile', '2025-12-13 23:19:09'),
(43, 10, 11, 'viewed_profile', 'Parent viewed child profile', '2025-12-13 23:19:09'),
(44, 10, 11, 'edited_profile', 'Parent updated child hair profile', '2025-12-13 23:19:09'),
(45, 10, 11, 'viewed_profile', 'Parent viewed child profile', '2025-12-13 23:19:10'),
(46, 12, 13, 'created', 'Created child account for nana', '2025-12-14 01:03:24'),
(47, 12, 13, 'viewed_profile', 'Parent viewed child profile', '2025-12-14 01:03:35');

-- --------------------------------------------------------

--
-- Table structure for table `pitfall_hair_type_applicability`
--

CREATE TABLE `pitfall_hair_type_applicability` (
  `applicability_id` int NOT NULL,
  `pitfall_id` int NOT NULL,
  `hair_type_id` int NOT NULL,
  `risk_level` enum('low','medium','high','critical') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `specific_notes` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pitfall_hair_type_applicability`
--

INSERT INTO `pitfall_hair_type_applicability` (`applicability_id`, `pitfall_id`, `hair_type_id`, `risk_level`, `specific_notes`) VALUES
(1, 1, 1, 'medium', 'Straight hair handles heat better but still risks damage'),
(2, 1, 7, 'high', 'Curl pattern can be permanently damaged'),
(3, 1, 10, 'critical', 'Coily hair is most vulnerable to heat damage'),
(4, 1, 12, 'critical', '4C hair extremely prone to heat damage'),
(5, 3, 1, 'low', 'Lower risk but edges still vulnerable'),
(6, 3, 7, 'medium', 'Moderate risk of traction'),
(7, 3, 10, 'high', 'High risk of traction alopecia'),
(8, 3, 12, 'critical', 'Extremely high risk, edges very fragile'),
(9, 6, 1, 'medium', 'Still risky even for straight hair'),
(10, 6, 7, 'high', 'Curls very vulnerable when wet'),
(11, 6, 10, 'critical', 'Extremely fragile when wet'),
(12, 6, 12, 'critical', '4C most fragile when wet, avoid brushing'),
(13, 5, 1, 'low', 'Can tolerate better but still strips oils'),
(14, 5, 7, 'medium', 'Removes natural oils curls need'),
(15, 5, 10, 'high', 'Very drying for coily hair'),
(16, 5, 12, 'high', 'Extremely harsh on 4C hair');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int NOT NULL,
  `product_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `brand` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `category` enum('shampoo','conditioner','deep_conditioner','leave_in','oil','serum','mask','styling','supplement','tool','protein_treatment','moisturizer','detangler','scalp_treatment','other') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `key_ingredients` text COLLATE utf8mb4_general_ci,
  `price` decimal(10,2) DEFAULT NULL,
  `amazon_link` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `image_url` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `rating` decimal(3,2) DEFAULT NULL,
  `is_sulfate_free` tinyint(1) DEFAULT '0',
  `is_paraben_free` tinyint(1) DEFAULT '0',
  `is_silicone_free` tinyint(1) DEFAULT '0',
  `is_natural` tinyint(1) DEFAULT '0',
  `is_vegan` tinyint(1) DEFAULT '0',
  `is_cruelty_free` tinyint(1) DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `product_name`, `brand`, `category`, `description`, `key_ingredients`, `price`, `amazon_link`, `image_url`, `rating`, `is_sulfate_free`, `is_paraben_free`, `is_silicone_free`, `is_natural`, `is_vegan`, `is_cruelty_free`, `created_at`, `updated_at`) VALUES
(1, 'Moisture Miracle Deep Conditioning Treatment', 'SheaMoisture', 'deep_conditioner', 'Intensive deep conditioner with raw shea butter for maximum moisture retention.', 'Shea Butter, Argan Oil, Sea Kelp', 12.99, NULL, NULL, 4.50, 1, 1, 1, 1, 0, 1, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(2, 'Coconut & Hibiscus Curl Enhancing Smoothie', 'SheaMoisture', 'styling', 'Curl defining cream that reduces frizz and adds shine to curls and coils.', 'Coconut Oil, Hibiscus Flower, Silk Protein', 11.49, NULL, NULL, 4.60, 1, 1, 1, 1, 0, 1, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(3, 'Castor Oil Hair Treatment', 'Sky Organics', 'oil', '100% pure Jamaican black castor oil for hair growth and thickness.', 'Jamaican Black Castor Oil', 15.99, NULL, NULL, 4.40, 1, 1, 1, 1, 1, 1, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(4, 'Protein Strong Leave-In Conditioner', 'Aphogee', 'leave_in', 'Protein-rich leave-in that strengthens and protects hair from damage.', 'Hydrolyzed Collagen, Keratin Amino Acids', 8.99, NULL, NULL, 4.30, 1, 1, 0, 0, 0, 0, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(5, 'Manuka Honey Intensive Hydration Masque', 'SheaMoisture', 'mask', 'Ultra-moisturizing hair masque for dry, damaged hair needing intensive care.', 'Manuka Honey, Mafura Oil, Baobab Oil', 13.99, NULL, NULL, 4.55, 1, 1, 1, 1, 0, 1, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(6, 'Tea Tree Special Shampoo', 'Paul Mitchell', 'shampoo', 'Clarifying shampoo that removes buildup while invigorating the scalp.', 'Tea Tree Oil, Peppermint, Lavender', 14.50, NULL, NULL, 4.65, 1, 1, 0, 0, 0, 1, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(7, 'Curl Defining Gel', 'Eco Styler', 'styling', 'Maximum hold gel that defines curls without flaking or crunchiness.', 'Olive Oil, Vitamin E', 3.99, NULL, NULL, 4.20, 1, 1, 0, 0, 1, 1, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(8, 'Argan Oil Treatment', 'Moroccan Oil', 'oil', 'Lightweight argan oil that adds shine and tames frizz without weighing hair down.', 'Argan Oil, Vitamin E', 34.00, NULL, NULL, 4.70, 1, 1, 1, 0, 0, 1, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(9, 'Rice Water Protein Treatment', 'Mielle Organics', 'protein_treatment', 'Strengthening protein treatment infused with rice water for damaged hair.', 'Rice Water, Biotin, Hydrolyzed Protein', 10.99, NULL, NULL, 4.45, 1, 1, 1, 1, 0, 1, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(10, 'Biotin Hair Growth Serum', 'Wild Growth', 'serum', 'Growth-promoting serum with biotin and natural oils for scalp health.', 'Biotin, Olive Oil, Jojoba Oil, Coconut Oil', 9.99, NULL, NULL, 4.35, 1, 1, 1, 1, 1, 1, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(11, 'Sweet Almond Oil Moisturizer', 'Carol\'s Daughter', 'moisturizer', 'Daily moisturizing cream that softens and detangles without buildup.', 'Sweet Almond Oil, Shea Butter, Rose Oil', 16.00, NULL, NULL, 4.40, 1, 1, 1, 1, 0, 1, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(12, 'Apple Cider Vinegar Rinse', 'dpHUE', 'scalp_treatment', 'Balancing scalp treatment that removes buildup and restores pH levels.', 'Apple Cider Vinegar, Lavender, Argan Oil', 35.00, NULL, NULL, 4.50, 1, 1, 1, 0, 0, 1, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(13, 'Protein Reconstructor', 'Aphogee', 'protein_treatment', 'Intense protein treatment for severely damaged or over-processed hair.', 'Hydrolyzed Collagen, Keratin, Animal Protein', 12.00, NULL, NULL, 4.60, 1, 1, 0, 0, 0, 0, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(14, 'Moisturizing Shampoo', 'As I Am', 'shampoo', 'Gentle sulfate-free cleanser that moisturizes while cleansing.', 'Coconut, Amla, Tangerine', 9.99, NULL, NULL, 4.55, 1, 1, 1, 1, 0, 1, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(15, 'Edge Control Gel', 'Hicks Edges', 'styling', 'Strong hold edge control for sleek styles without flaking.', 'Castor Oil, Beeswax', 4.99, NULL, NULL, 4.25, 1, 1, 0, 0, 0, 0, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(16, 'Rosemary Mint Scalp Oil', 'Mielle Organics', 'scalp_treatment', 'Stimulating scalp oil that promotes growth and soothes irritation.', 'Rosemary Oil, Peppermint Oil, Biotin', 9.99, NULL, NULL, 4.65, 1, 1, 1, 1, 1, 1, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(17, 'Detangling Spray', 'Kinky-Curly', 'detangler', 'Lightweight detangler that makes combing easier and reduces breakage.', 'Marshmallow Root, Slippery Elm, Lemongrass', 12.99, NULL, NULL, 4.50, 1, 1, 1, 1, 1, 1, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(18, 'Jamaican Black Castor Oil Conditioner', 'SheaMoisture', 'conditioner', 'Strengthening conditioner that promotes growth and reduces breakage.', 'Jamaican Black Castor Oil, Shea Butter, Peppermint', 11.99, NULL, NULL, 4.45, 1, 1, 1, 1, 0, 1, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(19, 'Curl Cream', 'Cantu', 'styling', 'Moisturizing curl cream that defines and holds curls all day.', 'Shea Butter, Coconut Oil, Honey', 5.99, NULL, NULL, 4.30, 1, 1, 1, 0, 0, 1, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(20, 'Peppermint Tea Tree Oil', 'Design Essentials', 'oil', 'Invigorating oil blend that stimulates scalp and promotes healthy growth.', 'Peppermint Oil, Tea Tree Oil, Eucalyptus', 14.00, NULL, NULL, 4.55, 1, 1, 1, 0, 0, 1, '2025-12-12 15:43:41', '2025-12-12 15:43:41'),
(21, 'Moisture Miracle Deep Conditioning Treatment', 'SheaMoisture', 'deep_conditioner', 'Intensive deep conditioner with raw shea butter for maximum moisture retention.', 'Shea Butter, Argan Oil, Sea Kelp', 12.99, NULL, NULL, 4.50, 1, 1, 1, 1, 0, 1, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(22, 'Coconut & Hibiscus Curl Enhancing Smoothie', 'SheaMoisture', 'styling', 'Curl defining cream that reduces frizz and adds shine to curls and coils.', 'Coconut Oil, Hibiscus Flower, Silk Protein', 11.49, NULL, NULL, 4.60, 1, 1, 1, 1, 0, 1, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(23, 'Castor Oil Hair Treatment', 'Sky Organics', 'oil', '100% pure Jamaican black castor oil for hair growth and thickness.', 'Jamaican Black Castor Oil', 15.99, NULL, NULL, 4.40, 1, 1, 1, 1, 1, 1, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(24, 'Protein Strong Leave-In Conditioner', 'Aphogee', 'leave_in', 'Protein-rich leave-in that strengthens and protects hair from damage.', 'Hydrolyzed Collagen, Keratin Amino Acids', 8.99, NULL, NULL, 4.30, 1, 1, 0, 0, 0, 0, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(25, 'Manuka Honey Intensive Hydration Masque', 'SheaMoisture', 'mask', 'Ultra-moisturizing hair masque for dry, damaged hair needing intensive care.', 'Manuka Honey, Mafura Oil, Baobab Oil', 13.99, NULL, NULL, 4.55, 1, 1, 1, 1, 0, 1, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(26, 'Tea Tree Special Shampoo', 'Paul Mitchell', 'shampoo', 'Clarifying shampoo that removes buildup while invigorating the scalp.', 'Tea Tree Oil, Peppermint, Lavender', 14.50, NULL, NULL, 4.65, 1, 1, 0, 0, 0, 1, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(27, 'Curl Defining Gel', 'Eco Styler', 'styling', 'Maximum hold gel that defines curls without flaking or crunchiness.', 'Olive Oil, Vitamin E', 3.99, NULL, NULL, 4.20, 1, 1, 0, 0, 1, 1, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(28, 'Argan Oil Treatment', 'Moroccan Oil', 'oil', 'Lightweight argan oil that adds shine and tames frizz without weighing hair down.', 'Argan Oil, Vitamin E', 34.00, NULL, NULL, 4.70, 1, 1, 1, 0, 0, 1, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(29, 'Rice Water Protein Treatment', 'Mielle Organics', 'protein_treatment', 'Strengthening protein treatment infused with rice water for damaged hair.', 'Rice Water, Biotin, Hydrolyzed Protein', 10.99, NULL, NULL, 4.45, 1, 1, 1, 1, 0, 1, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(30, 'Biotin Hair Growth Serum', 'Wild Growth', 'serum', 'Growth-promoting serum with biotin and natural oils for scalp health.', 'Biotin, Olive Oil, Jojoba Oil, Coconut Oil', 9.99, NULL, NULL, 4.35, 1, 1, 1, 1, 1, 1, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(31, 'Sweet Almond Oil Moisturizer', 'Carol\'s Daughter', 'moisturizer', 'Daily moisturizing cream that softens and detangles without buildup.', 'Sweet Almond Oil, Shea Butter, Rose Oil', 16.00, NULL, NULL, 4.40, 1, 1, 1, 1, 0, 1, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(32, 'Apple Cider Vinegar Rinse', 'dpHUE', 'scalp_treatment', 'Balancing scalp treatment that removes buildup and restores pH levels.', 'Apple Cider Vinegar, Lavender, Argan Oil', 35.00, NULL, NULL, 4.50, 1, 1, 1, 0, 0, 1, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(33, 'Protein Reconstructor', 'Aphogee', 'protein_treatment', 'Intense protein treatment for severely damaged or over-processed hair.', 'Hydrolyzed Collagen, Keratin, Animal Protein', 12.00, NULL, NULL, 4.60, 1, 1, 0, 0, 0, 0, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(34, 'Moisturizing Shampoo', 'As I Am', 'shampoo', 'Gentle sulfate-free cleanser that moisturizes while cleansing.', 'Coconut, Amla, Tangerine', 9.99, NULL, NULL, 4.55, 1, 1, 1, 1, 0, 1, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(35, 'Edge Control Gel', 'Hicks Edges', 'styling', 'Strong hold edge control for sleek styles without flaking.', 'Castor Oil, Beeswax', 4.99, NULL, NULL, 4.25, 1, 1, 0, 0, 0, 0, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(36, 'Rosemary Mint Scalp Oil', 'Mielle Organics', 'scalp_treatment', 'Stimulating scalp oil that promotes growth and soothes irritation.', 'Rosemary Oil, Peppermint Oil, Biotin', 9.99, NULL, NULL, 4.65, 1, 1, 1, 1, 1, 1, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(37, 'Detangling Spray', 'Kinky-Curly', 'detangler', 'Lightweight detangler that makes combing easier and reduces breakage.', 'Marshmallow Root, Slippery Elm, Lemongrass', 12.99, NULL, NULL, 4.50, 1, 1, 1, 1, 1, 1, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(38, 'Jamaican Black Castor Oil Conditioner', 'SheaMoisture', 'conditioner', 'Strengthening conditioner that promotes growth and reduces breakage.', 'Jamaican Black Castor Oil, Shea Butter, Peppermint', 11.99, NULL, NULL, 4.45, 1, 1, 1, 1, 0, 1, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(39, 'Curl Cream', 'Cantu', 'styling', 'Moisturizing curl cream that defines and holds curls all day.', 'Shea Butter, Coconut Oil, Honey', 5.99, NULL, NULL, 4.30, 1, 1, 1, 0, 0, 1, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(40, 'Peppermint Tea Tree Oil', 'Design Essentials', 'oil', 'Invigorating oil blend that stimulates scalp and promotes healthy growth.', 'Peppermint Oil, Tea Tree Oil, Eucalyptus', 14.00, NULL, NULL, 4.55, 1, 1, 1, 0, 0, 1, '2025-12-12 15:45:04', '2025-12-12 15:45:04'),
(41, 'Moisture Miracle Deep Conditioning Treatment', 'SheaMoisture', 'deep_conditioner', 'Intensive deep conditioner with raw shea butter for maximum moisture retention.', 'Shea Butter, Argan Oil, Sea Kelp', 12.99, NULL, NULL, 4.50, 1, 1, 1, 1, 0, 1, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(42, 'Coconut & Hibiscus Curl Enhancing Smoothie', 'SheaMoisture', 'styling', 'Curl defining cream that reduces frizz and adds shine to curls and coils.', 'Coconut Oil, Hibiscus Flower, Silk Protein', 11.49, NULL, NULL, 4.60, 1, 1, 1, 1, 0, 1, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(43, 'Castor Oil Hair Treatment', 'Sky Organics', 'oil', '100% pure Jamaican black castor oil for hair growth and thickness.', 'Jamaican Black Castor Oil', 15.99, NULL, NULL, 4.40, 1, 1, 1, 1, 1, 1, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(44, 'Protein Strong Leave-In Conditioner', 'Aphogee', 'leave_in', 'Protein-rich leave-in that strengthens and protects hair from damage.', 'Hydrolyzed Collagen, Keratin Amino Acids', 8.99, NULL, NULL, 4.30, 1, 1, 0, 0, 0, 0, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(45, 'Manuka Honey Intensive Hydration Masque', 'SheaMoisture', 'mask', 'Ultra-moisturizing hair masque for dry, damaged hair needing intensive care.', 'Manuka Honey, Mafura Oil, Baobab Oil', 13.99, NULL, NULL, 4.55, 1, 1, 1, 1, 0, 1, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(46, 'Tea Tree Special Shampoo', 'Paul Mitchell', 'shampoo', 'Clarifying shampoo that removes buildup while invigorating the scalp.', 'Tea Tree Oil, Peppermint, Lavender', 14.50, NULL, NULL, 4.65, 1, 1, 0, 0, 0, 1, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(47, 'Curl Defining Gel', 'Eco Styler', 'styling', 'Maximum hold gel that defines curls without flaking or crunchiness.', 'Olive Oil, Vitamin E', 3.99, NULL, NULL, 4.20, 1, 1, 0, 0, 1, 1, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(48, 'Argan Oil Treatment', 'Moroccan Oil', 'oil', 'Lightweight argan oil that adds shine and tames frizz without weighing hair down.', 'Argan Oil, Vitamin E', 34.00, NULL, NULL, 4.70, 1, 1, 1, 0, 0, 1, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(49, 'Rice Water Protein Treatment', 'Mielle Organics', 'protein_treatment', 'Strengthening protein treatment infused with rice water for damaged hair.', 'Rice Water, Biotin, Hydrolyzed Protein', 10.99, NULL, NULL, 4.45, 1, 1, 1, 1, 0, 1, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(50, 'Biotin Hair Growth Serum', 'Wild Growth', 'serum', 'Growth-promoting serum with biotin and natural oils for scalp health.', 'Biotin, Olive Oil, Jojoba Oil, Coconut Oil', 9.99, NULL, NULL, 4.35, 1, 1, 1, 1, 1, 1, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(51, 'Sweet Almond Oil Moisturizer', 'Carol\'s Daughter', 'moisturizer', 'Daily moisturizing cream that softens and detangles without buildup.', 'Sweet Almond Oil, Shea Butter, Rose Oil', 16.00, NULL, NULL, 4.40, 1, 1, 1, 1, 0, 1, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(52, 'Apple Cider Vinegar Rinse', 'dpHUE', 'scalp_treatment', 'Balancing scalp treatment that removes buildup and restores pH levels.', 'Apple Cider Vinegar, Lavender, Argan Oil', 35.00, NULL, NULL, 4.50, 1, 1, 1, 0, 0, 1, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(53, 'Protein Reconstructor', 'Aphogee', 'protein_treatment', 'Intense protein treatment for severely damaged or over-processed hair.', 'Hydrolyzed Collagen, Keratin, Animal Protein', 12.00, NULL, NULL, 4.60, 1, 1, 0, 0, 0, 0, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(54, 'Moisturizing Shampoo', 'As I Am', 'shampoo', 'Gentle sulfate-free cleanser that moisturizes while cleansing.', 'Coconut, Amla, Tangerine', 9.99, NULL, NULL, 4.55, 1, 1, 1, 1, 0, 1, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(55, 'Edge Control Gel', 'Hicks Edges', 'styling', 'Strong hold edge control for sleek styles without flaking.', 'Castor Oil, Beeswax', 4.99, NULL, NULL, 4.25, 1, 1, 0, 0, 0, 0, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(56, 'Rosemary Mint Scalp Oil', 'Mielle Organics', 'scalp_treatment', 'Stimulating scalp oil that promotes growth and soothes irritation.', 'Rosemary Oil, Peppermint Oil, Biotin', 9.99, NULL, NULL, 4.65, 1, 1, 1, 1, 1, 1, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(57, 'Detangling Spray', 'Kinky-Curly', 'detangler', 'Lightweight detangler that makes combing easier and reduces breakage.', 'Marshmallow Root, Slippery Elm, Lemongrass', 12.99, NULL, NULL, 4.50, 1, 1, 1, 1, 1, 1, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(58, 'Jamaican Black Castor Oil Conditioner', 'SheaMoisture', 'conditioner', 'Strengthening conditioner that promotes growth and reduces breakage.', 'Jamaican Black Castor Oil, Shea Butter, Peppermint', 11.99, NULL, NULL, 4.45, 1, 1, 1, 1, 0, 1, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(59, 'Curl Cream', 'Cantu', 'styling', 'Moisturizing curl cream that defines and holds curls all day.', 'Shea Butter, Coconut Oil, Honey', 5.99, NULL, NULL, 4.30, 1, 1, 1, 0, 0, 1, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(60, 'Peppermint Tea Tree Oil', 'Design Essentials', 'oil', 'Invigorating oil blend that stimulates scalp and promotes healthy growth.', 'Peppermint Oil, Tea Tree Oil, Eucalyptus', 14.00, NULL, NULL, 4.55, 1, 1, 1, 0, 0, 1, '2025-12-12 15:46:43', '2025-12-12 15:46:43'),
(61, 'SheaMoisture Coconut & Hibiscus Curl & Shine Shampoo', 'SheaMoisture', 'shampoo', 'Sulfate-free shampoo for curly and coily hair', 'Coconut Oil, Hibiscus, Shea Butter', 9.99, 'https://www.amazon.com/s?k=sheamoisture+coconut+hibiscus', NULL, 4.50, 0, 0, 0, 0, 0, 0, '2025-12-12 17:48:58', '2025-12-12 17:48:58'),
(62, 'Cantu Shea Butter for Natural Hair Leave-In Conditioning Repair Cream', 'Cantu', 'leave_in', 'Moisturizing leave-in conditioner for natural hair', 'Shea Butter, Coconut Oil, Jojoba Oil', 6.99, 'https://www.amazon.com/s?k=cantu+shea+butter', NULL, 4.60, 0, 0, 0, 0, 0, 0, '2025-12-12 17:48:58', '2025-12-12 17:48:58'),
(63, 'DevaCurl No-Poo Original Zero Lather Conditioning Cleanser', 'DevaCurl', 'shampoo', 'Sulfate-free cleanser for curly hair', 'Wheat Protein, Chamomile', 24.00, 'https://www.ulta.com/p/devacurl-no-poo', '', 4.40, 0, 0, 0, 0, 0, 0, '2025-12-12 17:48:58', '2025-12-12 17:48:58'),
(64, 'Jamaican Black Castor Oil', 'Tropic Isle Living', 'oil', 'Pure Jamaican black castor oil for hair growth', '100% Jamaican Black Castor Oil', 8.99, 'https://www.amazon.com/s?k=jamaican+black+castor+oil', NULL, 4.50, 0, 0, 0, 0, 0, 0, '2025-12-12 17:48:58', '2025-12-12 17:48:58'),
(65, 'Briogeo Don\'t Despair, Repair! Deep Conditioning Mask', 'Briogeo', 'mask', 'Repairing mask for damaged hair', 'Rosehip Oil, B vitamins, Algae Extract', 36.00, 'https://www.ulta.com/p/briogeo-dont-despair-repair', '', 4.60, 0, 0, 0, 0, 0, 0, '2025-12-12 17:48:58', '2025-12-12 17:48:58');

-- --------------------------------------------------------

--
-- Table structure for table `product_age_appropriateness`
--

CREATE TABLE `product_age_appropriateness` (
  `appropriateness_id` int NOT NULL,
  `product_id` int NOT NULL,
  `age_group` enum('child','teen','young_adult','adult','middle_aged','senior') COLLATE utf8mb4_general_ci NOT NULL,
  `suitability_score` int DEFAULT NULL,
  `age_specific_notes` text COLLATE utf8mb4_general_ci,
  `warnings` text COLLATE utf8mb4_general_ci
) ;

--
-- Dumping data for table `product_age_appropriateness`
--

INSERT INTO `product_age_appropriateness` (`appropriateness_id`, `product_id`, `age_group`, `suitability_score`, `age_specific_notes`, `warnings`) VALUES
(1, 1, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(2, 2, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(3, 3, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(4, 4, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(5, 5, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(6, 6, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(7, 7, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(8, 8, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(9, 9, 'child', 8, 'Gentle enough for children with natural ingredients', 'Protein treatments too strong for children - consult professional'),
(10, 10, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(11, 11, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(12, 12, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(13, 13, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', 'Protein treatments too strong for children - consult professional'),
(14, 14, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(15, 15, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(16, 16, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(17, 17, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(18, 18, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(19, 19, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(20, 20, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(21, 21, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(22, 22, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(23, 23, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(24, 24, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(25, 25, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(26, 26, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(27, 27, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(28, 28, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(29, 29, 'child', 8, 'Gentle enough for children with natural ingredients', 'Protein treatments too strong for children - consult professional'),
(30, 30, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(31, 31, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(32, 32, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(33, 33, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', 'Protein treatments too strong for children - consult professional'),
(34, 34, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(35, 35, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(36, 36, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(37, 37, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(38, 38, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(39, 39, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(40, 40, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(41, 41, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(42, 42, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(43, 43, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(44, 44, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(45, 45, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(46, 46, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(47, 47, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(48, 48, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(49, 49, 'child', 8, 'Gentle enough for children with natural ingredients', 'Protein treatments too strong for children - consult professional'),
(50, 50, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(51, 51, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(52, 52, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(53, 53, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', 'Protein treatments too strong for children - consult professional'),
(54, 54, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(55, 55, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(56, 56, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(57, 57, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(58, 58, 'child', 8, 'Gentle enough for children with natural ingredients', NULL),
(59, 59, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(60, 60, 'child', 6, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL),
(61, 61, 'child', 3, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', 'Contains sulfates - not recommended for children under 12'),
(62, 62, 'child', 3, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', 'Contains sulfates - not recommended for children under 12'),
(63, 63, 'child', 3, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', 'Contains sulfates - not recommended for children under 12'),
(64, 64, 'child', 3, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', 'Contains sulfates - not recommended for children under 12'),
(65, 65, 'child', 3, 'Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', 'Contains sulfates - not recommended for children under 12'),
(128, 1, 'senior', 9, 'Excellent for mature hair - provides needed moisture and gentle care', NULL),
(129, 3, 'senior', 9, 'Excellent for mature hair - provides needed moisture and gentle care', NULL),
(130, 8, 'senior', 9, 'Excellent for mature hair - provides needed moisture and gentle care', NULL),
(131, 11, 'senior', 9, 'Excellent for mature hair - provides needed moisture and gentle care', NULL),
(132, 20, 'senior', 9, 'Excellent for mature hair - provides needed moisture and gentle care', NULL),
(133, 21, 'senior', 9, 'Excellent for mature hair - provides needed moisture and gentle care', NULL),
(134, 23, 'senior', 9, 'Excellent for mature hair - provides needed moisture and gentle care', NULL),
(135, 28, 'senior', 9, 'Excellent for mature hair - provides needed moisture and gentle care', NULL),
(136, 31, 'senior', 9, 'Excellent for mature hair - provides needed moisture and gentle care', NULL),
(137, 40, 'senior', 9, 'Excellent for mature hair - provides needed moisture and gentle care', NULL),
(138, 41, 'senior', 9, 'Excellent for mature hair - provides needed moisture and gentle care', NULL),
(139, 43, 'senior', 9, 'Excellent for mature hair - provides needed moisture and gentle care', NULL),
(140, 48, 'senior', 9, 'Excellent for mature hair - provides needed moisture and gentle care', NULL),
(141, 51, 'senior', 9, 'Excellent for mature hair - provides needed moisture and gentle care', NULL),
(142, 60, 'senior', 9, 'Excellent for mature hair - provides needed moisture and gentle care', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `product_hair_type_compatibility`
--

CREATE TABLE `product_hair_type_compatibility` (
  `compatibility_id` int NOT NULL,
  `product_id` int NOT NULL,
  `hair_type_id` int NOT NULL,
  `compatibility_score` int DEFAULT NULL,
  `notes` text COLLATE utf8mb4_general_ci
) ;

--
-- Dumping data for table `product_hair_type_compatibility`
--

INSERT INTO `product_hair_type_compatibility` (`compatibility_id`, `product_id`, `hair_type_id`, `compatibility_score`, `notes`) VALUES
(1, 1, 7, 10, 'Excellent for 3A curls, provides perfect moisture balance'),
(2, 1, 8, 9, 'Great for 3B, may need follow-up with heavier products'),
(3, 1, 9, 9, 'Works well for 3C, gentle cleansing without stripping'),
(4, 1, 10, 8, 'Good for 4A, might need additional moisture after'),
(5, 1, 11, 8, 'Suitable for 4B, pair with rich conditioner'),
(6, 1, 12, 8, 'Works for 4C, follow with intensive conditioning'),
(7, 2, 7, 10, 'Perfect curl definition for 3A'),
(8, 2, 8, 10, 'Excellent results for 3B curls'),
(9, 2, 9, 9, 'Great for 3C, provides moisture and definition'),
(10, 2, 10, 9, 'Works wonderfully for 4A hair'),
(11, 2, 11, 8, 'Good for 4B, may need additional sealant'),
(12, 2, 12, 7, 'Can work for 4C, might be too light alone'),
(13, 4, 7, 7, 'Can be heavy for 3A, use sparingly'),
(14, 4, 8, 8, 'Good for 3B in small amounts'),
(15, 4, 9, 9, 'Excellent for 3C hair'),
(16, 4, 10, 10, 'Perfect for 4A, great moisture sealant'),
(17, 4, 11, 10, 'Ideal for 4B, excellent for growth'),
(18, 4, 12, 10, 'Best for 4C, heavy moisture and growth promotion'),
(19, 7, 7, 9, 'Lightweight and perfect for 3A'),
(20, 7, 8, 9, 'Excellent for 3B curl types'),
(21, 7, 9, 10, 'Perfect for 3C detangling'),
(22, 7, 10, 10, 'Ideal for 4A hair'),
(23, 7, 11, 9, 'Great for 4B, excellent slip'),
(24, 7, 12, 9, 'Very good for 4C detangling'),
(25, 1, 1, 7, 'Works for 1A but may be heavy - use sparingly'),
(26, 1, 2, 7, 'Good for 1B in small amounts'),
(27, 1, 3, 8, 'Suitable for 1C hair'),
(28, 1, 4, 8, 'Works well for 2A waves'),
(29, 1, 5, 9, 'Excellent for 2B'),
(30, 1, 6, 9, 'Great for 2C hair'),
(31, 2, 4, 6, 'May be too heavy for 2A'),
(32, 2, 5, 7, 'Good for 2B but use sparingly'),
(33, 2, 6, 8, 'Works well for 2C'),
(34, 3, 1, 5, 'Too heavy for 1A - use on ends only'),
(35, 3, 2, 6, 'Can work for 1B in small amounts'),
(36, 3, 3, 7, 'Good for 1C hair'),
(37, 3, 4, 7, 'Acceptable for 2A on ends'),
(38, 3, 5, 8, 'Good for 2B hair'),
(39, 3, 6, 9, 'Excellent for 2C'),
(40, 3, 7, 9, 'Great for 3A curls'),
(41, 3, 8, 9, 'Very good for 3B'),
(42, 3, 9, 10, 'Perfect for 3C'),
(43, 3, 10, 10, 'Ideal for 4A'),
(44, 3, 11, 10, 'Excellent for 4B'),
(45, 3, 12, 10, 'Best for 4C hair'),
(46, 4, 1, 6, 'Light protein good for 1A'),
(47, 4, 2, 7, 'Works for 1B'),
(48, 4, 3, 8, 'Good for 1C'),
(49, 4, 4, 7, 'Suitable for 2A'),
(50, 4, 5, 8, 'Good for 2B'),
(51, 4, 6, 9, 'Excellent for 2C'),
(52, 4, 7, 9, 'Great for 3A'),
(53, 4, 8, 9, 'Very good for 3B'),
(54, 4, 9, 10, 'Perfect for 3C'),
(55, 4, 10, 10, 'Ideal for 4A'),
(56, 4, 11, 10, 'Excellent for 4B'),
(57, 4, 12, 10, 'Best for 4C'),
(58, 61, 12, 9, 'Fetched from amazon'),
(59, 62, 12, 9, 'Fetched from amazon'),
(60, 63, 12, 8, 'Fetched from ulta'),
(61, 64, 12, 9, 'Fetched from amazon'),
(62, 65, 12, 9, 'Fetched from ulta'),
(63, 61, 11, 9, 'Fetched from amazon'),
(64, 62, 11, 9, 'Fetched from amazon'),
(65, 63, 11, 8, 'Fetched from ulta'),
(66, 64, 11, 9, 'Fetched from amazon'),
(67, 65, 11, 9, 'Fetched from ulta'),
(68, 65, 1, 9, 'Fetched from ulta'),
(69, 63, 1, 8, 'Fetched from ulta');

-- --------------------------------------------------------

--
-- Table structure for table `protective_styles`
--

CREATE TABLE `protective_styles` (
  `style_id` int NOT NULL,
  `style_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `category` enum('braids','twists','locs','wigs','weaves','updos','buns','cornrows','other') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `difficulty_level` enum('beginner','intermediate','advanced','expert') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `expected_longevity_days` int DEFAULT NULL,
  `maintenance_instructions` text COLLATE utf8mb4_general_ci,
  `installation_time` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cost_range` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `common_mistakes` text COLLATE utf8mb4_general_ci,
  `removal_instructions` text COLLATE utf8mb4_general_ci,
  `image_url` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `video_tutorial_url` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `protective_styles`
--

INSERT INTO `protective_styles` (`style_id`, `style_name`, `category`, `description`, `difficulty_level`, `expected_longevity_days`, `maintenance_instructions`, `installation_time`, `cost_range`, `common_mistakes`, `removal_instructions`, `image_url`, `video_tutorial_url`, `created_at`) VALUES
(1, 'Box Braids', 'braids', 'Individual plaited braids that can be worn in various lengths and thicknesses, offering versatile styling options.', 'intermediate', 56, 'Moisturize scalp every 2-3 days. Tie down with silk scarf at night. Wash every 2 weeks with diluted shampoo. Apply light oil to braids weekly.', '4-8 hours', '$150-$300', 'Installing too tight causing tension alopecia. Not moisturizing scalp. Keeping in too long. Sleeping without protection.', '1. Cut braids to shoulder length. 2. Carefully unbraid from ends to roots. 3. Apply oil while unbraiding. 4. Detangle each section. 5. Deep condition immediately after removal.', 'https://authenticafricanhairbraiding.com/blog/wp-content/uploads/2024/12/Knotless-Box-Braids.jpg', 'https://www.youtube.com/watch?v=h7spCXYLndY', '2025-12-12 16:04:09'),
(2, 'Senegalese Twists', 'twists', 'Two-strand rope twists using braiding hair for length and fullness, smooth and elegant appearance.', 'intermediate', 42, 'Oil scalp 2-3 times per week. Sleep with satin bonnet. Wash bi-weekly with focus on scalp. Refresh edges with gel as needed.', '5-7 hours', '$120-$250', 'Twisting too tight. Using too much hair causing heaviness. Not sealing ends properly. Over-manipulating style.', '1. Untwist each section from bottom up. 2. Apply conditioner for slip. 3. Gently separate twists. 4. Remove extension hair. 5. Detangle carefully. 6. Deep condition and protein treat.', 'https://www.ottawadivinushair.com/cdn/shop/files/Ottawa_Divinus_Hair_Salon_Senegalese_Twist_Small_9cb5f354-b644-46d6-abce-739b901db1dd_grande.jpg?v=1713485898', 'https://www.youtube.com/watch?v=iLxu_VzSxQo', '2025-12-12 16:04:09'),
(3, 'Faux Locs', 'locs', 'Temporary loc style created by wrapping hair around extensions, mimicking real locs without commitment.', 'advanced', 63, 'Keep scalp clean with witch hazel or diluted shampoo. Moisturize roots every 3 days. Retouch edges weekly. Sleep with satin bonnet.', '6-10 hours', '$200-$400', 'Installing too heavy causing neck strain. Not maintaining scalp health. Keeping in past 8 weeks. Rough removal causing breakage.', '1. Cut locs to manageable length. 2. Carefully unwrap from bottom. 3. Use oil generously. 4. Take your time - don\'t rush. 5. Deep condition thoroughly. 6. Give hair a break before next install.', 'https://frohub.com/wp-content/uploads/2025/07/brown-faux-locs-1.jpg', 'https://www.youtube.com/shorts/yyLgDNNFKVs', '2025-12-12 16:04:09'),
(4, 'Cornrows', 'cornrows', 'Braids plaited close to scalp in straight lines or intricate patterns, classic protective style.', 'intermediate', 21, 'Oil scalp every other day. Tie down nightly. Can last 2-3 weeks. Cleanse scalp with cotton ball and witch hazel.', '2-4 hours', '$50-$150', 'Braiding too tight especially at hairline. Not laying hair down at night. Over-manipulating fresh braids. Ignoring scalp care.', '1. Unbraid gently from ends to roots. 2. Apply oil as you unbraid. 3. Be patient with tangled areas. 4. Detangle with wide-tooth comb. 5. Shampoo and deep condition.', 'https://cdn.tuko.co.ke/images/1120/0fgjhs6dhtlueruj6.jpeg?v=1', 'https://www.youtube.com/watch?v=EBJMXmawzB4', '2025-12-12 16:04:09'),
(5, 'Crochet Braids', 'braids', 'Hair extensions crocheted into cornrow base, offering quick installation and versatile styling.', 'beginner', 35, 'Sleep with satin bonnet. Moisturize underneath cornrows every 2-3 days. Can wash gently. Refresh curls with water spray if needed.', '2-3 hours', '$80-$200', 'Not securing wefts properly causing slippage. Neglecting cornrow base. Over-styling causing tangling. Tight base braids.', '1. Cut wefts out carefully. 2. Unbraid cornrow base. 3. Detangle gently. 4. Cleanse and deep condition. 5. Let hair rest before next style.', 'https://www.youtube.com/shorts/fPPdwFItfNo', 'https://hips.hearstapps.com/hmg-prod/images/indigo2-1536264277.jpg?crop=1.00xw:0.845xh;0,0.0934xh', '2025-12-12 16:04:09'),
(6, 'Passion Twists', 'twists', 'Bohemian style twists using water wave or curly hair for textured, carefree appearance.', 'intermediate', 42, 'Moisturize daily with light spray. Sleep with bonnet. Can wash gently with focus on scalp. Refresh with mousse or foam.', '4-6 hours', '$150-$250', 'Using too much hair making twists bulky. Installing too tight. Not maintaining the curly texture. Excessive manipulation.', '1. Carefully unravel each twist. 2. Apply oil or conditioner for slip. 3. Gently remove extension hair. 4. Detangle in sections. 5. Deep condition thoroughly.', 'https://i.ytimg.com/vi/J1Glg6m5h2M/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLBBE6V36j0UnlZ1HnbLu8WNSeiORQ', 'https://www.youtube.com/watch?v=IbR9dQSAzO0', '2025-12-12 16:04:09'),
(7, 'Fulani Braids', 'braids', 'Traditional style with cornrows in center and braids on sides, often adorned with beads and cuffs.', 'advanced', 28, 'Oil scalp every 2-3 days. Protect at night with silk scarf. Can last 3-4 weeks with proper care. Touch up edges as needed.', '4-6 hours', '$100-$200', 'Braiding too tight especially center and sides. Heavy beads causing tension. Not moisturizing scalp. Keeping in too long.', '1. Remove beads and accessories. 2. Unbraid carefully. 3. Use oil to ease process. 4. Detangle gently. 5. Deep condition and moisturize.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBhXqMahGUviwxqwaPYFxVwnUO_G-4x0iKiw&s', 'https://www.youtube.com/watch?v=e0Pv42tWk64', '2025-12-12 16:04:09'),
(8, 'High Puff', 'updos', 'Simple updo gathering hair at crown in rounded puff shape, quick and easy protective style.', 'beginner', 1, 'Can be done daily. Use satin scrunchies. Don\'t pull too tight. Moisturize before styling. Give edges a break regularly.', '5-10 minutes', '$0', 'Using regular elastic bands. Pulling too tight causing traction alopecia. Not smoothing edges gently. Same position daily.', 'Simply release hair from scrunchie. Gently fluff and separate. Can detangle or leave for wash day.', 'https://frohub.com/wp-content/uploads/2024/11/high-puff-1-300x300.jpg', 'https://www.youtube.com/shorts/TZddenw9Ljc', '2025-12-12 16:04:09'),
(9, 'Bantu Knots', 'twists', 'Small sections twisted and coiled into knots, can be worn as knots or unraveled for curls.', 'intermediate', 7, 'Sleep with satin bonnet to preserve knots. Can last up to a week. Moisturize sections before creating. Oil scalp between knots.', '1-3 hours', '$0-$80 (if professional)', 'Creating knots on dry hair. Making them too tight. Not securing ends properly. Using wrong products.', '1. Carefully unwind each knot. 2. Apply oil to fingers. 3. Gently separate curls if desired. 4. Fluff for volume. 5. Can leave as is or style.', 'https://www.youtube.com/watch?v=WFHp6MExqkY', 'https://frohub.com/wp-content/uploads/2024/10/natural-hair-bantu-knots.jpg', '2025-12-12 16:04:09'),
(10, 'Flat Twists', 'twists', 'Two-strand twists done close to scalp, similar to cornrows but twisted instead of braided.', 'intermediate', 14, 'Oil scalp every 2-3 days. Tie down nightly with silk scarf. Can last 1-2 weeks. Refresh edges with gel.', '1-3 hours', '$0-$100', 'Twisting too tight. Using too much product causing buildup. Not following hair\'s natural pattern. Neglecting scalp.', '1. Untwist gently from ends to roots. 2. Apply oil as you untwist. 3. Detangle sections. 4. Can wear twist-out or wash. 5. Deep condition if washing.', 'https://www.instyle.com/thmb/J2rHvirIf-qb87KG7oSA17SYlUI=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/flattwists-5d7a99823e66474c95a049c0fc644ca9.jpg', 'https://www.youtube.com/watch?v=CDZhnYb1dqI', '2025-12-12 16:04:09'),
(11, 'Wig Install', 'wigs', 'Wearing wig cap over braided or slicked down natural hair, ultimate low-manipulation protection.', 'beginner', 30, 'Remove nightly or every few days to let scalp breathe. Moisturize braids underneath. Wash natural hair weekly or bi-weekly.', '30 minutes - 2 hours', '$30-$300+', 'Not protecting natural hair underneath. Wearing too tight causing edges to thin. Not maintaining hair under wig. Sleeping in wig.', '1. Remove wig carefully. 2. Take down braids underneath. 3. Detangle gently. 4. Cleanse scalp and hair. 5. Deep condition. 6. Let hair breathe.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2Mz0JCrm_oOhE9znnavWvwe2eFS42fCMVDw&s', 'https://www.youtube.com/watch?v=3P09mZZcUvM', '2025-12-12 16:04:09'),
(12, 'Havana Twists', 'twists', 'Chunky, fuller rope twists using Havana hair for a bold, voluminous look.', 'intermediate', 42, 'Moisturize scalp 2-3 times weekly. Sleep with satin bonnet. Can last 4-6 weeks. Wash carefully focusing on scalp.', '3-5 hours', '$120-$220', 'Making twists too thick causing heaviness. Installing too tight. Poor scalp maintenance. Keeping in too long.', '1. Untwist from bottom to top. 2. Apply generous oil or conditioner. 3. Remove extension hair carefully. 4. Detangle in sections. 5. Deep condition immediately.', 'https://www.byrdie.com/thmb/q5AmMm9dIjtdZ4j37PGkuOlu0gM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/58656946_144384473283010_97023956721831759_n-250f7d28821a46fa93e3c01d486060fa.jpg', 'https://www.youtube.com/watch?v=z9MsuSyhCdc', '2025-12-12 16:04:09');

-- --------------------------------------------------------

--
-- Table structure for table `routine_completion_log`
--

CREATE TABLE `routine_completion_log` (
  `log_id` int NOT NULL,
  `routine_id` int NOT NULL,
  `profile_id` int NOT NULL,
  `completion_date` date NOT NULL,
  `completed_steps` text COLLATE utf8mb4_general_ci,
  `skipped_steps` text COLLATE utf8mb4_general_ci,
  `notes` text COLLATE utf8mb4_general_ci,
  `overall_rating` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ;

--
-- Dumping data for table `routine_completion_log`
--

INSERT INTO `routine_completion_log` (`log_id`, `routine_id`, `profile_id`, `completion_date`, `completed_steps`, `skipped_steps`, `notes`, `overall_rating`, `created_at`) VALUES
(1, 37, 10, '2025-12-14', NULL, NULL, 'Completed via app', NULL, '2025-12-14 14:13:45'),
(2, 39, 10, '2025-12-14', NULL, NULL, 'Completed via app', NULL, '2025-12-14 16:02:05');

-- --------------------------------------------------------

--
-- Table structure for table `routine_steps`
--

CREATE TABLE `routine_steps` (
  `step_id` int NOT NULL,
  `routine_id` int NOT NULL,
  `step_order` int NOT NULL,
  `step_name` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `method_id` int DEFAULT NULL,
  `duration` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `instructions` text COLLATE utf8mb4_general_ci,
  `is_optional` tinyint(1) DEFAULT '0',
  `frequency_note` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `routine_steps`
--

INSERT INTO `routine_steps` (`step_id`, `routine_id`, `step_order`, `step_name`, `product_id`, `method_id`, `duration`, `instructions`, `is_optional`, `frequency_note`) VALUES
(34, 10, 1, 'Gentle Detangling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(35, 10, 2, 'Moisturize', 1, NULL, '2-3 minutes', '0', 0, NULL),
(36, 10, 3, 'Seal with Oil', 4, NULL, '1-2 minutes', '0', 0, NULL),
(37, 11, 1, 'Protective Styling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(38, 11, 2, 'Satin/Silk Protection', NULL, NULL, '1 minute', '0', 0, NULL),
(39, 12, 1, 'Pre-Poo Treatment', NULL, NULL, '30-60 minutes', '0', 1, NULL),
(40, 12, 2, 'Shampoo', 1, NULL, '5-10 minutes', '0', 0, NULL),
(41, 12, 3, 'Condition', 4, NULL, '5-10 minutes', '0', 0, NULL),
(42, 12, 4, 'Deep Condition', NULL, NULL, '20-30 minutes', '0', 1, NULL),
(43, 12, 5, 'Leave-In Conditioner', 4, NULL, '2-3 minutes', '0', 0, NULL),
(44, 12, 6, 'Style', NULL, NULL, '15-30 minutes', '0', 0, NULL),
(45, 13, 1, 'Gentle Detangling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(46, 13, 2, 'Moisturize', 4, NULL, '2-3 minutes', '0', 0, NULL),
(47, 13, 3, 'Seal with Oil', 4, NULL, '1-2 minutes', '0', 0, NULL),
(48, 14, 1, 'Protective Styling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(49, 14, 2, 'Satin/Silk Protection', NULL, NULL, '1 minute', '0', 0, NULL),
(50, 15, 1, 'Pre-Poo Treatment', 3, NULL, '30-60 minutes', '0', 1, NULL),
(51, 15, 2, 'Shampoo', 4, NULL, '5-10 minutes', '0', 0, NULL),
(52, 15, 3, 'Condition', 4, NULL, '5-10 minutes', '0', 0, NULL),
(53, 15, 4, 'Deep Condition', 64, NULL, '20-30 minutes', '0', 1, NULL),
(54, 15, 5, 'Leave-In Conditioner', 4, NULL, '2-3 minutes', '0', 0, NULL),
(55, 15, 6, 'Style', NULL, NULL, '15-30 minutes', '0', 0, NULL),
(56, 16, 1, 'Gentle Detangling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(57, 16, 2, 'Moisturize', 4, NULL, '2-3 minutes', '0', 0, NULL),
(58, 16, 3, 'Seal with Oil', 7, NULL, '1-2 minutes', '0', 0, NULL),
(59, 17, 1, 'Protective Styling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(60, 17, 2, 'Satin/Silk Protection', NULL, NULL, '1 minute', '0', 0, NULL),
(61, 18, 1, 'Pre-Poo Treatment', 3, NULL, '30-60 minutes', '0', 1, NULL),
(62, 18, 2, 'Shampoo', 4, NULL, '5-10 minutes', '0', 0, NULL),
(63, 18, 3, 'Condition', 7, NULL, '5-10 minutes', '0', 0, NULL),
(64, 18, 4, 'Deep Condition', 4, NULL, '20-30 minutes', '0', 1, NULL),
(65, 18, 5, 'Leave-In Conditioner', 7, NULL, '2-3 minutes', '0', 0, NULL),
(66, 18, 6, 'Style', NULL, NULL, '15-30 minutes', '0', 0, NULL),
(67, 19, 1, 'Gentle Detangling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(68, 19, 2, 'Moisturize', 4, NULL, '2-3 minutes', '0', 0, NULL),
(69, 19, 3, 'Seal with Oil', 7, NULL, '1-2 minutes', '0', 0, NULL),
(70, 20, 1, 'Protective Styling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(71, 20, 2, 'Satin/Silk Protection', NULL, NULL, '1 minute', '0', 0, NULL),
(72, 21, 1, 'Pre-Poo Treatment', 3, NULL, '30-60 minutes', '0', 1, NULL),
(73, 21, 2, 'Shampoo', 4, NULL, '5-10 minutes', '0', 0, NULL),
(74, 21, 3, 'Condition', 7, NULL, '5-10 minutes', '0', 0, NULL),
(75, 21, 4, 'Deep Condition', 4, NULL, '20-30 minutes', '0', 1, NULL),
(76, 21, 5, 'Leave-In Conditioner', 7, NULL, '2-3 minutes', '0', 0, NULL),
(77, 21, 6, 'Style', NULL, NULL, '15-30 minutes', '0', 0, NULL),
(78, 22, 1, 'Gentle Detangling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(79, 22, 2, 'Moisturize', 4, NULL, '2-3 minutes', '0', 0, NULL),
(80, 22, 3, 'Seal with Oil', 7, NULL, '1-2 minutes', '0', 0, NULL),
(81, 23, 1, 'Protective Styling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(82, 23, 2, 'Satin/Silk Protection', NULL, NULL, '1 minute', '0', 0, NULL),
(83, 24, 1, 'Pre-Poo Treatment', 3, NULL, '30-60 minutes', '0', 1, NULL),
(84, 24, 2, 'Shampoo', 4, NULL, '5-10 minutes', '0', 0, NULL),
(85, 24, 3, 'Condition', 7, NULL, '5-10 minutes', '0', 0, NULL),
(86, 24, 4, 'Deep Condition', 4, NULL, '20-30 minutes', '0', 1, NULL),
(87, 24, 5, 'Leave-In Conditioner', 7, NULL, '2-3 minutes', '0', 0, NULL),
(88, 24, 6, 'Style', NULL, NULL, '15-30 minutes', '0', 0, NULL),
(89, 25, 1, 'Gentle Detangling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(90, 25, 2, 'Moisturize', 4, NULL, '2-3 minutes', '0', 0, NULL),
(91, 25, 3, 'Seal with Oil', 7, NULL, '1-2 minutes', '0', 0, NULL),
(92, 26, 1, 'Protective Styling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(93, 26, 2, 'Satin/Silk Protection', NULL, NULL, '1 minute', '0', 0, NULL),
(94, 27, 1, 'Pre-Poo Treatment', 3, NULL, '30-60 minutes', '0', 1, NULL),
(95, 27, 2, 'Shampoo', 4, NULL, '5-10 minutes', '0', 0, NULL),
(96, 27, 3, 'Condition', 7, NULL, '5-10 minutes', '0', 0, NULL),
(97, 27, 4, 'Deep Condition', 4, NULL, '20-30 minutes', '0', 1, NULL),
(98, 27, 5, 'Leave-In Conditioner', 7, NULL, '2-3 minutes', '0', 0, NULL),
(99, 27, 6, 'Style', NULL, NULL, '15-30 minutes', '0', 0, NULL),
(100, 28, 1, 'Gentle Detangling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(101, 28, 2, 'Moisturize', 4, NULL, '2-3 minutes', '0', 0, NULL),
(102, 28, 3, 'Seal with Oil', 7, NULL, '1-2 minutes', '0', 0, NULL),
(103, 29, 1, 'Protective Styling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(104, 29, 2, 'Satin/Silk Protection', NULL, NULL, '1 minute', '0', 0, NULL),
(105, 30, 1, 'Pre-Poo Treatment', 3, NULL, '30-60 minutes', '0', 1, NULL),
(106, 30, 2, 'Shampoo', 4, NULL, '5-10 minutes', '0', 0, NULL),
(107, 30, 3, 'Condition', 7, NULL, '5-10 minutes', '0', 0, NULL),
(108, 30, 4, 'Deep Condition', 4, NULL, '20-30 minutes', '0', 1, NULL),
(109, 30, 5, 'Leave-In Conditioner', 7, NULL, '2-3 minutes', '0', 0, NULL),
(110, 30, 6, 'Style', NULL, NULL, '15-30 minutes', '0', 0, NULL),
(111, 31, 1, 'Gentle Detangling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(112, 31, 2, 'Moisturize', 4, NULL, '2-3 minutes', '0', 0, NULL),
(113, 31, 3, 'Seal with Oil', 7, NULL, '1-2 minutes', '0', 0, NULL),
(114, 32, 1, 'Protective Styling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(115, 32, 2, 'Satin/Silk Protection', NULL, NULL, '1 minute', '0', 0, NULL),
(116, 33, 1, 'Pre-Poo Treatment', 3, NULL, '30-60 minutes', '0', 1, NULL),
(117, 33, 2, 'Shampoo', 4, NULL, '5-10 minutes', '0', 0, NULL),
(118, 33, 3, 'Condition', 7, NULL, '5-10 minutes', '0', 0, NULL),
(119, 33, 4, 'Deep Condition', 4, NULL, '20-30 minutes', '0', 1, NULL),
(120, 33, 5, 'Leave-In Conditioner', 7, NULL, '2-3 minutes', '0', 0, NULL),
(121, 33, 6, 'Style', NULL, NULL, '15-30 minutes', '0', 0, NULL),
(122, 34, 1, 'Gentle Detangling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(123, 34, 2, 'Moisturize', 1, NULL, '2-3 minutes', '0', 0, NULL),
(124, 34, 3, 'Seal with Oil', 3, NULL, '1-2 minutes', '0', 0, NULL),
(125, 35, 1, 'Protective Styling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(126, 35, 2, 'Satin/Silk Protection', NULL, NULL, '1 minute', '0', 0, NULL),
(127, 36, 1, 'Pre-Poo Treatment', 4, NULL, '30-60 minutes', '0', 1, NULL),
(128, 36, 2, 'Shampoo', 1, NULL, '5-10 minutes', '0', 0, NULL),
(129, 36, 3, 'Condition', 3, NULL, '5-10 minutes', '0', 0, NULL),
(130, 36, 4, 'Deep Condition', 2, NULL, '20-30 minutes', '0', 1, NULL),
(131, 36, 5, 'Leave-In Conditioner', 3, NULL, '2-3 minutes', '0', 0, NULL),
(132, 36, 6, 'Style', NULL, NULL, '15-30 minutes', '0', 0, NULL),
(133, 37, 1, 'Gentle Detangling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(134, 37, 2, 'Moisturize', 4, NULL, '2-3 minutes', '0', 0, NULL),
(135, 37, 3, 'Seal with Oil', 7, NULL, '1-2 minutes', '0', 0, NULL),
(136, 38, 1, 'Protective Styling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(137, 38, 2, 'Satin/Silk Protection', NULL, NULL, '1 minute', '0', 0, NULL),
(138, 39, 1, 'Pre-Poo Treatment', 3, NULL, '30-60 minutes', '0', 1, NULL),
(139, 39, 2, 'Shampoo', 4, NULL, '5-10 minutes', '0', 0, NULL),
(140, 39, 3, 'Condition', 7, NULL, '5-10 minutes', '0', 0, NULL),
(141, 39, 4, 'Deep Condition', 4, NULL, '20-30 minutes', '0', 1, NULL),
(142, 39, 5, 'Leave-In Conditioner', 7, NULL, '2-3 minutes', '0', 0, NULL),
(143, 39, 6, 'Style', NULL, NULL, '15-30 minutes', '0', 0, NULL),
(144, 40, 1, 'Gentle Detangling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(145, 40, 2, 'Moisturize', 4, NULL, '2-3 minutes', '0', 0, NULL),
(146, 40, 3, 'Seal with Oil', 7, NULL, '1-2 minutes', '0', 0, NULL),
(147, 41, 1, 'Protective Styling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(148, 41, 2, 'Satin/Silk Protection', NULL, NULL, '1 minute', '0', 0, NULL),
(149, 42, 1, 'Pre-Poo Treatment', 3, NULL, '30-60 minutes', '0', 1, NULL),
(150, 42, 2, 'Shampoo', 4, NULL, '5-10 minutes', '0', 0, NULL),
(151, 42, 3, 'Condition', 7, NULL, '5-10 minutes', '0', 0, NULL),
(152, 42, 4, 'Deep Condition', 4, NULL, '20-30 minutes', '0', 1, NULL),
(153, 42, 5, 'Leave-In Conditioner', 7, NULL, '2-3 minutes', '0', 0, NULL),
(154, 42, 6, 'Style', NULL, NULL, '15-30 minutes', '0', 0, NULL),
(155, 43, 1, 'Gentle Detangling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(156, 43, 2, 'Moisturize', 4, NULL, '2-3 minutes', '0', 0, NULL),
(157, 43, 3, 'Seal with Oil', 7, NULL, '1-2 minutes', '0', 0, NULL),
(158, 44, 1, 'Protective Styling', NULL, NULL, '5-10 minutes', '0', 0, NULL),
(159, 44, 2, 'Satin/Silk Protection', NULL, NULL, '1 minute', '0', 0, NULL),
(160, 45, 1, 'Pre-Poo Treatment', 3, NULL, '30-60 minutes', '0', 1, NULL),
(161, 45, 2, 'Shampoo', 4, NULL, '5-10 minutes', '0', 0, NULL),
(162, 45, 3, 'Condition', 7, NULL, '5-10 minutes', '0', 0, NULL),
(163, 45, 4, 'Deep Condition', 4, NULL, '20-30 minutes', '0', 1, NULL),
(164, 45, 5, 'Leave-In Conditioner', 7, NULL, '2-3 minutes', '0', 0, NULL),
(165, 45, 6, 'Style', NULL, NULL, '15-30 minutes', '0', 0, NULL),
(166, 37, 1, 'Gentle Detangling', NULL, NULL, '5-10 min', 'Use wide-tooth comb', 0, NULL),
(167, 37, 2, 'Moisturize', NULL, NULL, '2-3 min', 'Apply leave-in conditioner', 0, NULL),
(168, 38, 1, 'Protective Styling', NULL, NULL, '5-10 min', 'Braid or wrap hair', 0, NULL),
(169, 39, 1, 'Shampoo', NULL, NULL, '5-10 min', 'Wash with sulfate-free shampoo', 0, NULL),
(170, 39, 2, 'Condition', NULL, NULL, '5-10 min', 'Apply conditioner', 0, NULL),
(171, 40, 1, 'Gentle Detangling', NULL, NULL, '5-10 min', 'Use wide-tooth comb', 0, NULL),
(172, 40, 2, 'Moisturize', NULL, NULL, '2-3 min', 'Apply leave-in conditioner', 0, NULL),
(173, 41, 1, 'Protective Styling', NULL, NULL, '5-10 min', 'Braid or wrap hair', 0, NULL),
(174, 42, 1, 'Shampoo', NULL, NULL, '5-10 min', 'Wash with sulfate-free shampoo', 0, NULL),
(175, 42, 2, 'Condition', NULL, NULL, '5-10 min', 'Apply conditioner', 0, NULL),
(176, 43, 1, 'Gentle Detangling', NULL, NULL, '5-10 min', 'Use wide-tooth comb', 0, NULL),
(177, 43, 2, 'Moisturize', NULL, NULL, '2-3 min', 'Apply leave-in conditioner', 0, NULL),
(178, 44, 1, 'Protective Styling', NULL, NULL, '5-10 min', 'Braid or wrap hair', 0, NULL),
(179, 45, 1, 'Shampoo', NULL, NULL, '5-10 min', 'Wash with sulfate-free shampoo', 0, NULL),
(180, 45, 2, 'Condition', NULL, NULL, '5-10 min', 'Apply conditioner', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `style_hair_type_compatibility`
--

CREATE TABLE `style_hair_type_compatibility` (
  `compatibility_id` int NOT NULL,
  `style_id` int NOT NULL,
  `hair_type_id` int NOT NULL,
  `suitability_score` int DEFAULT NULL,
  `special_considerations` text COLLATE utf8mb4_general_ci
) ;

--
-- Dumping data for table `style_hair_type_compatibility`
--

INSERT INTO `style_hair_type_compatibility` (`compatibility_id`, `style_id`, `hair_type_id`, `suitability_score`, `special_considerations`) VALUES
(1, 1, 7, 8, 'Works well for 3A, may need smaller sections'),
(2, 1, 8, 9, 'Great for 3B hair'),
(3, 1, 9, 10, 'Excellent for 3C curls'),
(4, 1, 10, 10, 'Perfect for 4A, ideal texture'),
(5, 1, 11, 10, 'Ideal for 4B hair'),
(6, 1, 12, 10, 'Best suited for 4C, excellent protection'),
(7, 4, 7, 7, 'Possible for 3A but may not last as long'),
(8, 4, 8, 8, 'Good for 3B with proper products'),
(9, 4, 9, 9, 'Works well for 3C'),
(10, 4, 10, 10, 'Excellent for 4A hair'),
(11, 4, 11, 10, 'Perfect for 4B texture'),
(12, 4, 12, 10, 'Ideal for 4C hair'),
(13, 9, 7, 9, 'Great option for 3A curls'),
(14, 9, 8, 10, 'Perfect for 3B hair'),
(15, 9, 9, 10, 'Excellent for 3C curls'),
(16, 9, 10, 10, 'Wonderful for 4A'),
(17, 9, 11, 9, 'Good for 4B with proper smoothing'),
(18, 9, 12, 8, 'Works for 4C but requires more prep'),
(19, 12, 1, 10, 'Universal - works for all hair types'),
(20, 12, 7, 10, 'Universal - works for all hair types'),
(21, 12, 10, 10, 'Universal - works for all hair types'),
(22, 12, 12, 10, 'Universal - works for all hair types'),
(23, 1, 1, 5, 'Not ideal for 1A - hair may slip out'),
(24, 1, 2, 6, 'Can work for 1B with proper grip products'),
(25, 1, 3, 7, 'Suitable for 1C with care'),
(26, 1, 4, 7, 'Possible for 2A with smaller sections'),
(27, 1, 5, 8, 'Good for 2B hair'),
(28, 1, 6, 8, 'Works well for 2C'),
(29, 2, 1, 4, 'Difficult for 1A - too slippery'),
(30, 2, 2, 5, 'Challenging for 1B'),
(31, 2, 3, 6, 'Can work for 1C'),
(32, 2, 4, 6, 'Possible for 2A'),
(33, 2, 5, 7, 'Good for 2B'),
(34, 2, 6, 8, 'Works well for 2C'),
(35, 2, 7, 9, 'Excellent for 3A'),
(36, 2, 8, 9, 'Great for 3B'),
(37, 2, 9, 10, 'Perfect for 3C'),
(38, 2, 10, 10, 'Ideal for 4A'),
(39, 2, 11, 10, 'Excellent for 4B'),
(40, 2, 12, 10, 'Best for 4C'),
(41, 3, 7, 9, 'Great for 3A curls'),
(42, 3, 8, 9, 'Excellent for 3B'),
(43, 3, 9, 10, 'Perfect for 3C'),
(44, 3, 10, 10, 'Ideal for 4A'),
(45, 3, 11, 10, 'Excellent for 4B'),
(46, 3, 12, 10, 'Best suited for 4C'),
(47, 8, 2, 6, 'Can work for 1B with gel'),
(48, 8, 3, 7, 'Good for 1C'),
(49, 8, 4, 8, 'Works well for 2A'),
(50, 8, 5, 9, 'Great for 2B'),
(51, 8, 6, 9, 'Excellent for 2C'),
(52, 8, 7, 10, 'Perfect for 3A'),
(53, 8, 8, 10, 'Ideal for 3B'),
(54, 8, 9, 10, 'Excellent for 3C'),
(55, 8, 10, 10, 'Great for 4A'),
(56, 8, 11, 10, 'Perfect for 4B'),
(57, 8, 12, 10, 'Ideal for 4C');

-- --------------------------------------------------------

--
-- Table structure for table `symptom_cause_mapping`
--

CREATE TABLE `symptom_cause_mapping` (
  `mapping_id` int NOT NULL,
  `symptom_id` int NOT NULL,
  `cause_id` int NOT NULL,
  `likelihood_score` int DEFAULT NULL,
  `explanation` text COLLATE utf8mb4_general_ci
) ;

--
-- Dumping data for table `symptom_cause_mapping`
--

INSERT INTO `symptom_cause_mapping` (`mapping_id`, `symptom_id`, `cause_id`, `likelihood_score`, `explanation`) VALUES
(1, 1, 1, 9, 'Heat damage weakens hair structure leading to breakage'),
(2, 1, 2, 8, 'Over-manipulation causes mechanical breakage'),
(3, 1, 3, 9, 'Protein-moisture imbalance makes hair brittle and prone to snapping'),
(4, 1, 5, 8, 'Chemical damage compromises hair integrity'),
(5, 2, 4, 8, 'Sulfates strip natural oils leaving hair dry'),
(6, 2, 10, 9, 'Low porosity hair struggles to absorb moisture'),
(7, 2, 16, 7, 'Dry climate pulls moisture from hair'),
(8, 3, 9, 7, 'Product buildup can cause flaking'),
(9, 3, 14, 9, 'Fungal infections are primary cause of dandruff'),
(10, 4, 9, 8, 'Product buildup irritates scalp'),
(11, 4, 14, 9, 'Fungal infection causes itching and irritation'),
(12, 4, 4, 6, 'Harsh sulfates can irritate sensitive scalps'),
(13, 5, 7, 8, 'Hormonal imbalance disrupts hair growth cycle'),
(14, 5, 13, 9, 'Stress pushes hair into shedding phase'),
(15, 5, 12, 7, 'Vitamin deficiency weakens hair follicles'),
(16, 6, 7, 8, 'Hormonal changes can cause thinning'),
(17, 6, 8, 7, 'Traction alopecia from tight styles'),
(18, 6, 15, 6, 'Thyroid issues affect hair density'),
(19, 7, 1, 8, 'Heat styling causes split ends'),
(20, 7, 2, 7, 'Rough handling leads to split ends'),
(21, 8, 1, 8, 'Heat damage causes breakage at same rate as growth'),
(22, 8, 3, 7, 'Imbalanced hair breaks preventing length retention'),
(23, 8, 6, 6, 'Poor nutrition slows growth rate'),
(24, 1, 6, 9, 'Chemical treatments weaken hair structure causing mid-shaft breakage'),
(25, 1, 12, 8, 'Over-manipulation from constant styling causes mechanical breakage'),
(26, 1, 14, 7, 'Sulfates strip protective oils leading to brittle hair'),
(27, 2, 3, 9, 'Moisture deficiency is primary cause of dry, rough hair'),
(28, 2, 13, 8, 'Hard water minerals coat hair preventing moisture absorption'),
(29, 2, 14, 8, 'Harsh sulfates remove natural oils'),
(30, 3, 8, 8, 'Product buildup clogs follicles and causes flaking'),
(31, 3, 11, 7, 'Poor scalp health leads to dandruff and irritation'),
(32, 4, 6, 7, 'Chemical treatments can burn and irritate scalp'),
(33, 4, 8, 7, 'Heavy product buildup irritates scalp'),
(34, 5, 4, 7, 'Iron deficiency causes telogen effluvium'),
(35, 5, 5, 6, 'Vitamin D deficiency affects hair growth cycle'),
(36, 5, 9, 9, 'Hormonal imbalances disrupt normal hair cycle'),
(37, 5, 10, 9, 'Chronic stress triggers excessive shedding'),
(38, 6, 7, 9, 'Traction alopecia from tight styles causes permanent thinning'),
(39, 6, 9, 8, 'Hormonal changes affect follicle health'),
(40, 6, 10, 7, 'Prolonged stress can cause hair loss'),
(41, 7, 6, 8, 'Chemical damage causes ends to split and fray'),
(42, 7, 12, 8, 'Over-manipulation and rough handling causes splits'),
(43, 8, 4, 7, 'Iron deficiency slows hair growth rate'),
(44, 8, 10, 7, 'Stress affects growth phase duration'),
(45, 8, 11, 8, 'Poor scalp health restricts follicle function'),
(46, 8, 15, 8, 'Low protein intake reduces keratin production');

-- --------------------------------------------------------

--
-- Table structure for table `treatment_solutions`
--

CREATE TABLE `treatment_solutions` (
  `solution_id` int NOT NULL,
  `cause_id` int NOT NULL,
  `solution_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `solution_type` enum('product','method','lifestyle_change','professional_treatment','dietary','medical') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `instructions` text COLLATE utf8mb4_general_ci,
  `expected_timeframe` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `method_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `treatment_solutions`
--

INSERT INTO `treatment_solutions` (`solution_id`, `cause_id`, `solution_name`, `solution_type`, `description`, `instructions`, `expected_timeframe`, `product_id`, `method_id`) VALUES
(1, 1, 'Reduce Heat Styling', 'lifestyle_change', 'Limit heat tool use to maximum 2 times per week', 'Air dry whenever possible, use heat protectant when styling, use lowest effective temperature', '2-3 months for improvement', NULL, NULL),
(2, 1, 'Deep Conditioning Treatment', 'product', 'Weekly intensive moisture treatment', 'Apply deep conditioner to damp hair, cover with cap, leave 30 mins with heat, rinse', 'Immediate improvement, 1-2 months for full recovery', 3, 3),
(3, 2, 'Adopt Low Manipulation Routine', 'method', 'Minimize daily handling of hair', 'Choose simple protective styles, detangle gently when wet only, avoid constant touching', '1-2 months', NULL, NULL),
(4, 3, 'Balanced Protein-Moisture Treatment', 'product', 'Alternate between protein and moisture treatments', 'Assess hair needs, alternate protein and moisture weekly based on results', '3-4 weeks', 6, 8),
(5, 4, 'Switch to Sulfate-Free Shampoo', 'product', 'Use gentle, sulfate-free cleansers', 'Replace current shampoo with sulfate-free option, shampoo less frequently', '2-3 weeks', 1, NULL),
(6, 5, 'Protein Reconstructor Treatment', 'product', 'Intensive protein treatment for chemically damaged hair', 'Follow product instructions carefully, usually every 4-6 weeks', '6-8 weeks', 6, 8),
(7, 6, 'Improve Diet and Take Supplements', 'dietary', 'Eat nutrient-rich foods and take hair vitamins', 'Take biotin supplement daily, eat protein, leafy greens, nuts, fish', '3-6 months', NULL, 11),
(8, 7, 'Consult Healthcare Provider', 'medical', 'Medical evaluation and possible hormone therapy', 'Schedule appointment with endocrinologist or dermatologist', 'Varies by treatment', NULL, NULL),
(9, 8, 'Loosen Hairstyles', 'lifestyle_change', 'Stop wearing tight styles, give edges a break', 'Wear loose styles, massage hairline, avoid tension', '2-3 months minimum', NULL, NULL),
(10, 9, 'Clarifying Treatment', 'product', 'Monthly clarifying wash to remove buildup', 'Use clarifying shampoo once monthly, rinse thoroughly, follow with deep conditioner', '1 wash', 15, NULL),
(11, 10, 'Steam Treatment', 'method', 'Use heat with deep conditioning to open cuticles', 'Apply conditioner, sit under steamer or use warm towel, leave 30 minutes', '4-6 weeks of regular use', 3, 3),
(12, 11, 'Protein Filler Treatment', 'product', 'Use protein treatments and heavier sealants', 'Apply protein treatment bi-weekly, seal moisture with heavier oils', '4-6 weeks', 6, 8),
(13, 12, 'Multivitamin Supplementation', 'dietary', 'Daily multivitamin with iron and B-vitamins', 'Take quality multivitamin daily, increase iron-rich foods', '2-3 months', NULL, NULL),
(14, 13, 'Stress Management Program', 'lifestyle_change', 'Implement stress reduction techniques', 'Practice meditation, exercise regularly, adequate sleep, therapy if needed', '1-3 months', NULL, NULL),
(15, 14, 'Antifungal Scalp Treatment', 'medical', 'Medicated shampoo or treatment for fungal infection', 'Use antifungal shampoo as directed, usually 2-3 times weekly', '2-4 weeks', 11, NULL),
(16, 16, 'Increase Moisture Routine', 'lifestyle_change', 'More frequent moisturizing and hydration', 'Use humidifier, increase water intake, moisturize hair daily', '2-4 weeks', NULL, NULL),
(17, 17, 'Chelating Treatment', 'product', 'Remove mineral buildup from hard water', 'Use chelating shampoo monthly, consider shower filter', '1-2 treatments', 15, NULL),
(18, 18, 'Pre-Swim Protection Routine', 'lifestyle_change', 'Protect hair before swimming', 'Wet hair, apply leave-in conditioner, wear swim cap, rinse immediately after', 'Immediate protection', 7, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `first_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `last_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `gender` enum('female','male','other','prefer_not_to_say') COLLATE utf8mb4_general_ci DEFAULT 'female',
  `date_of_birth` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `offline_mode_enabled` tinyint(1) DEFAULT '1',
  `last_sync` timestamp NULL DEFAULT NULL,
  `hormonal_status` enum('pre_puberty','puberty','reproductive','perimenopause','menopause','post_menopause','andropause','not_applicable') COLLATE utf8mb4_general_ci DEFAULT 'not_applicable',
  `parent_user_id` int DEFAULT NULL,
  `is_child_account` tinyint(1) DEFAULT '0',
  `child_age_when_created` int DEFAULT NULL,
  `failed_login_attempts` int DEFAULT '0',
  `lockout_until` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `email`, `password_hash`, `first_name`, `last_name`, `gender`, `date_of_birth`, `created_at`, `updated_at`, `last_login`, `is_active`, `offline_mode_enabled`, `last_sync`, `hormonal_status`, `parent_user_id`, `is_child_account`, `child_age_when_created`, `failed_login_attempts`, `lockout_until`) VALUES
(2, 'happy@gmail.com', '$2y$10$vGr5w47.UsgvvEYVyohsNuqdMan6YpSgqYNILyVGSlUpIkXkyjrem', 'Wylie', 'Mccray', 'other', NULL, '2025-12-12 21:28:43', '2025-12-13 23:15:53', '2025-12-12 21:28:50', 1, 1, NULL, 'not_applicable', NULL, 0, NULL, 6, '2025-12-13 23:20:53'),
(3, 'joycelyn@gmail.com', '$2y$10$wnH/T/MsuUgORlHkZiXh7uDn7a0wx/XP0JLXbGYx.pB1Vc94SoHS2', 'Joycelyn', 'Allan', 'female', '2002-06-20', '2025-12-12 22:01:39', '2025-12-13 23:17:36', '2025-12-12 22:01:49', 1, 1, NULL, 'not_applicable', NULL, 0, NULL, 5, '2025-12-13 23:22:36'),
(4, 'bell@gmail.com', '$2y$10$leunaUAreklFFlj41EHg7e4X7dG34I.z9s5KTaR1609Q9yiHTcMQO', 'Hanna', 'Bell', 'prefer_not_to_say', '1999-11-16', '2025-12-12 22:46:49', '2025-12-13 10:16:27', '2025-12-13 10:16:27', 1, 1, NULL, 'not_applicable', NULL, 0, NULL, 0, NULL),
(6, 'bell.drian1765581824@maneflow.child', '$2y$10$wJb9hlsgoLwGvTNzEtJL9.MfuXBoA0Wdu7R8kGBJHq7unVdHoae0C', 'Adrian', 'Molina', 'female', '2019-03-14', '2025-12-12 23:23:44', '2025-12-12 23:23:44', NULL, 1, 1, NULL, 'not_applicable', 4, 1, 6, 0, NULL),
(7, 'here@gmail.com', '$2y$10$SUJJ9E/VNXyx/VYXwHENU.wbMnXghyDOu/GxnRkvdB4VIizOpIxUy', 'Skyler', 'Alvarez', 'female', '1915-06-04', '2025-12-13 21:52:31', '2025-12-13 21:52:43', '2025-12-13 21:52:43', 1, 1, NULL, 'not_applicable', NULL, 0, NULL, 0, NULL),
(8, 'here.ulie1765664385@maneflow.child', '$2y$10$.hcV9ET9d7JhaD7T1hVLLeU9bTSfB0UxbJl4JFTjSNZiYS2xTnbXq', 'Julie', 'Newton', 'female', '2025-12-10', '2025-12-13 22:19:45', '2025-12-13 22:19:45', NULL, 1, 1, NULL, 'not_applicable', 7, 1, 0, 0, NULL),
(9, 'here.acey1765664413@maneflow.child', '$2y$10$Vet8bAecX3dLMh6GEWPuwehkt8JRVDa9KxpaSNmI6jPULPTWtpghW', 'Lacey', 'Terrell', 'female', '2022-10-11', '2025-12-13 22:20:13', '2025-12-13 22:20:13', NULL, 1, 1, NULL, 'not_applicable', 7, 1, 3, 0, NULL),
(10, 'race@gmail.com', '$2y$10$N1ioP9cBd0ySHWI8xhvhn.dfOb6bVgR27Q2yn.xMxS3PaKXy6T13u', 'Beau', 'Cardenas', 'female', '1922-11-09', '2025-12-13 23:18:28', '2025-12-14 14:13:32', '2025-12-14 14:13:32', 1, 1, NULL, 'not_applicable', NULL, 0, NULL, 0, NULL),
(11, 'race.ames1765667940@maneflow.child', '$2y$10$VF4Pa.Q7KukyrupaLbHY1u0drwMuRI/8yJ1WMDFv5fEIfmE1pBKle', 'James', 'Snyder', 'prefer_not_to_say', '2023-07-26', '2025-12-13 23:19:00', '2025-12-13 23:19:00', NULL, 1, 1, NULL, 'not_applicable', 10, 1, 2, 0, NULL),
(12, 'akua.amponsah@ashesi.edu.gh', '$2y$10$9M4pskNaP8nxHeCER8YSLuR3tVe8GmKiVN.eAd/wie.Iur9cen6qG', 'Nana', 'Akua', 'female', '2008-02-08', '2025-12-14 00:47:53', '2025-12-14 00:48:07', '2025-12-14 00:48:07', 1, 1, NULL, 'not_applicable', NULL, 0, NULL, 0, NULL),
(13, 'akua.amponsah.nana1765674204@maneflow.child', '$2y$10$VeWV1IxSJUNcJE0FUSlzKe9n3Ko4CKznGipk5rK6/OuasFurlBlSK', 'nana', 'akua', 'female', '2025-12-02', '2025-12-14 01:03:24', '2025-12-14 01:03:24', NULL, 1, 1, NULL, 'not_applicable', 12, 1, 0, 0, NULL),
(14, 'hagendickson604@gmail.com', '$2y$10$KPP2wLUqhiCQb5UAUL59au9MtLt1iTmn4kWh.DktE2MBSzI3q3qiO', 'Hagen', 'Dickson', 'male', '2005-06-06', '2025-12-14 11:47:24', '2025-12-14 16:39:44', '2025-12-14 16:39:44', 1, 1, NULL, 'not_applicable', NULL, 0, NULL, 0, NULL),
(15, 'andrea.babilah@gmqil.com', '$2y$10$uKAlZs2KaBhyGJZ9GcW.G..CnLRsjGSnov3dDHl1XSpYxpsRf/Qq6', 'Andrea', 'Babilah', 'female', '2000-11-17', '2025-12-14 13:24:25', '2025-12-14 13:34:29', '2025-12-14 13:34:29', 1, 1, NULL, 'not_applicable', NULL, 0, NULL, 0, NULL),
(16, 'papatello321@gmail.com', '$2y$10$uW4Cvfx0RzlwrzlKgydm2uqZn1ECq0Pg4oTlWkEuaOdCaQko65g0i', 'Susan', 'NELSON', 'female', '2005-01-24', '2025-12-14 16:41:26', '2025-12-14 16:41:35', '2025-12-14 16:41:35', 1, 1, NULL, 'not_applicable', NULL, 0, NULL, 0, NULL),
(17, 'edwinallan23@gmail.com', '$2y$10$qaZkPNZ0WHvOhBTc4swF5uSl0YpQjXJOTCihJfAsR9k1469aIBc46', 'Edwin', 'Allan', 'male', '1995-11-17', '2025-12-14 20:57:09', '2025-12-14 20:57:23', '2025-12-14 20:57:23', 1, 1, NULL, 'not_applicable', NULL, 0, NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_diagnoses`
--

CREATE TABLE `user_diagnoses` (
  `diagnosis_id` int NOT NULL,
  `profile_id` int NOT NULL,
  `diagnosis_date` date NOT NULL,
  `symptoms_reported` text COLLATE utf8mb4_general_ci,
  `identified_causes` text COLLATE utf8mb4_general_ci,
  `recommended_solutions` text COLLATE utf8mb4_general_ci,
  `is_resolved` tinyint(1) DEFAULT '0',
  `follow_up_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_diagnoses`
--

INSERT INTO `user_diagnoses` (`diagnosis_id`, `profile_id`, `diagnosis_date`, `symptoms_reported`, `identified_causes`, `recommended_solutions`, `is_resolved`, `follow_up_date`, `created_at`) VALUES
(3, 3, '2025-12-12', 'Hair Breakage at Mid-Shaft, Scalp Redness, Visible Scalp Through Hair, Split Ends, Hair Growing Very Slowly', 'Protein Overload, Moisture Deficiency, Chemical Damage, Heat Damage, Vitamin D Deficiency', 'Reduce Heat Styling, Deep Conditioning Treatment, Adopt Low Manipulation Routine, Balanced Protein-Moisture Treatment, Protein Reconstructor Treatment, Improve Diet and Take Supplements', 0, NULL, '2025-12-12 21:32:27'),
(4, 5, '2025-12-13', 'Hair Breakage at Mid-Shaft, Hair in Brush/Comb, Itchy Scalp, Thinning at Crown, Split Ends', 'Protein Overload, Moisture Deficiency, Chemical Damage, Traction Alopecia, Heat Damage', 'Reduce Heat Styling, Deep Conditioning Treatment, Adopt Low Manipulation Routine, Balanced Protein-Moisture Treatment, Improve Diet and Take Supplements, Consult Healthcare Provider', 0, NULL, '2025-12-13 16:26:44'),
(5, 5, '2025-12-13', 'Lack of Shine/Dullness', '', '', 0, NULL, '2025-12-13 16:29:12'),
(6, 6, '2025-12-13', 'Lack of Shine/Dullness', '', '', 0, NULL, '2025-12-13 16:31:52'),
(7, 6, '2025-12-13', 'Lack of Shine/Dullness', '', '', 0, NULL, '2025-12-13 16:32:16'),
(8, 5, '2025-12-13', 'Cradle Cap, Tangles and Knots', 'Immature oil glands, buildup; Active play, sensitive scalp, improper detangling', 'Gentle brushing, baby shampoo, consult pediatrician if severe; Detangle spray, wide-tooth comb, patience, make it fun', 0, NULL, '2025-12-13 16:38:06'),
(9, 6, '2025-12-13', 'Postpartum Shedding', 'Hormonal shifts after pregnancy', 'Temporary condition, gentle care, proper nutrition, patience', 0, NULL, '2025-12-13 16:39:11'),
(10, 5, '2025-12-13', 'Tangles and Knots, Head Lice, Excessive Hair in Drain', 'Associated with Tangles and Knots; Associated with Head Lice; Hard Water; Hormonal Imbalance; Chronic Stress; Traction Alopecia; Over-Manipulation', 'Recommendation for Tangles and Knots; Recommendation for Head Lice; Consult Healthcare Provider; Clarifying Treatment; Steam Treatment; Multivitamin Supplementation; Stress Management Program', 0, NULL, '2025-12-13 16:42:27'),
(11, 7, '2025-12-13', 'Brittle Hair Syndrome, Hair Growing Very Slowly, Hair Becoming More Brittle', 'Associated with Brittle Hair Syndrome', 'Recommendation for Brittle Hair Syndrome', 0, NULL, '2025-12-13 22:11:15'),
(12, 7, '2025-12-13', 'Brittle Hair Syndrome, Excessive Dryness, Single Strand Knots', 'Associated with Brittle Hair Syndrome; Chronic Stress; Moisture Deficiency; Iron Deficiency; Hard Water; Sulfate Damage; Heat Damage', 'Recommendation for Brittle Hair Syndrome; Balanced Protein-Moisture Treatment; Switch to Sulfate-Free Shampoo; Steam Treatment; Stress Management Program; Antifungal Scalp Treatment; Increase Moisture Routine', 0, NULL, '2025-12-13 22:23:32'),
(13, 8, '2025-12-13', 'Cradle Cap, Tangles and Knots, Yellow Oily Flakes, Receding Hairline', 'Associated with Cradle Cap; Associated with Tangles and Knots; Sulfate Damage; Hormonal Imbalance; Chemical Damage; Product Build-up; Iron Deficiency', 'Recommendation for Cradle Cap; Recommendation for Tangles and Knots; Switch to Sulfate-Free Shampoo; Improve Diet and Take Supplements; Loosen Hairstyles; Clarifying Treatment; Antifungal Scalp Treatment', 0, NULL, '2025-12-13 23:01:11'),
(14, 12, '2025-12-14', 'Excessive Oiliness, White Flaky Scalp, Hair in Brush/Comb, Single Strand Knots, No Length Progress', 'Associated with Excessive Oiliness; Sulfate Damage; Traction Alopecia; Product Build-up; Traction Alopecia; Hormonal Imbalance; Hormonal Imbalance; Poor Scalp Health; Product Build-up; Chronic Stress; Low Protein Intake', 'Recommendation for Excessive Oiliness; Consult Healthcare Provider; Loosen Hairstyles; Clarifying Treatment; Steam Treatment; Protein Filler Treatment; Antifungal Scalp Treatment', 0, NULL, '2025-12-14 00:59:55');

-- --------------------------------------------------------

--
-- Table structure for table `user_hair_concerns`
--

CREATE TABLE `user_hair_concerns` (
  `user_concern_id` int NOT NULL,
  `profile_id` int NOT NULL,
  `concern_id` int NOT NULL,
  `severity` enum('mild','moderate','severe') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `noted_date` date DEFAULT NULL,
  `symptoms_selected` text COLLATE utf8mb4_general_ci,
  `is_resolved` tinyint(1) DEFAULT '0',
  `resolved_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_hair_concerns`
--

INSERT INTO `user_hair_concerns` (`user_concern_id`, `profile_id`, `concern_id`, `severity`, `noted_date`, `symptoms_selected`, `is_resolved`, `resolved_date`) VALUES
(17, 3, 2, 'mild', '2025-12-12', NULL, 0, NULL),
(18, 3, 9, 'mild', '2025-12-12', NULL, 0, NULL),
(19, 3, 3, 'mild', '2025-12-12', NULL, 0, NULL),
(20, 3, 22, 'mild', '2025-12-12', NULL, 0, NULL),
(21, 3, 21, 'mild', '2025-12-12', NULL, 0, NULL),
(22, 3, 24, 'mild', '2025-12-12', NULL, 0, NULL),
(23, 3, 4, 'mild', '2025-12-12', NULL, 0, NULL),
(24, 3, 1, 'mild', '2025-12-12', NULL, 0, NULL),
(25, 3, 10, 'mild', '2025-12-12', NULL, 0, NULL),
(26, 3, 23, 'mild', '2025-12-12', NULL, 0, NULL),
(27, 3, 25, 'mild', '2025-12-12', NULL, 0, NULL),
(28, 3, 6, 'mild', '2025-12-12', NULL, 0, NULL),
(29, 3, 7, 'mild', '2025-12-12', NULL, 0, NULL),
(30, 3, 5, 'mild', '2025-12-12', NULL, 0, NULL),
(31, 3, 8, 'mild', '2025-12-12', NULL, 0, NULL),
(32, 3, 26, 'mild', '2025-12-12', NULL, 0, NULL),
(65, 4, 2, 'mild', '2025-12-12', NULL, 0, NULL),
(66, 4, 9, 'mild', '2025-12-12', NULL, 0, NULL),
(67, 4, 3, 'mild', '2025-12-12', NULL, 0, NULL),
(68, 4, 22, 'mild', '2025-12-12', NULL, 0, NULL),
(69, 4, 21, 'mild', '2025-12-12', NULL, 0, NULL),
(70, 4, 24, 'mild', '2025-12-12', NULL, 0, NULL),
(71, 4, 4, 'mild', '2025-12-12', NULL, 0, NULL),
(72, 4, 1, 'mild', '2025-12-12', NULL, 0, NULL),
(73, 4, 10, 'mild', '2025-12-12', NULL, 0, NULL),
(74, 4, 23, 'mild', '2025-12-12', NULL, 0, NULL),
(75, 4, 25, 'mild', '2025-12-12', NULL, 0, NULL),
(76, 4, 6, 'mild', '2025-12-12', NULL, 0, NULL),
(77, 4, 7, 'mild', '2025-12-12', NULL, 0, NULL),
(78, 4, 5, 'mild', '2025-12-12', NULL, 0, NULL),
(79, 4, 8, 'mild', '2025-12-12', NULL, 0, NULL),
(80, 4, 26, 'mild', '2025-12-12', NULL, 0, NULL),
(145, 5, 2, 'mild', '2025-12-12', NULL, 0, NULL),
(146, 5, 9, 'mild', '2025-12-12', NULL, 0, NULL),
(147, 5, 3, 'severe', '2025-12-12', NULL, 0, NULL),
(148, 5, 22, 'mild', '2025-12-12', NULL, 0, NULL),
(149, 5, 21, 'mild', '2025-12-12', NULL, 0, NULL),
(150, 5, 24, 'mild', '2025-12-12', NULL, 0, NULL),
(151, 5, 4, 'mild', '2025-12-12', NULL, 0, NULL),
(152, 5, 1, 'moderate', '2025-12-12', NULL, 0, NULL),
(153, 5, 10, 'mild', '2025-12-12', NULL, 0, NULL),
(154, 5, 23, 'moderate', '2025-12-12', NULL, 0, NULL),
(155, 5, 25, 'mild', '2025-12-12', NULL, 0, NULL),
(156, 5, 6, 'mild', '2025-12-12', NULL, 0, NULL),
(157, 5, 7, 'mild', '2025-12-12', NULL, 0, NULL),
(158, 5, 5, 'severe', '2025-12-12', NULL, 0, NULL),
(159, 5, 8, 'mild', '2025-12-12', NULL, 0, NULL),
(160, 5, 26, 'mild', '2025-12-12', NULL, 0, NULL),
(161, 6, 2, 'mild', '2025-12-12', NULL, 0, NULL),
(162, 6, 9, 'mild', '2025-12-12', NULL, 0, NULL),
(163, 6, 3, 'moderate', '2025-12-12', NULL, 0, NULL),
(164, 6, 22, 'moderate', '2025-12-12', NULL, 0, NULL),
(165, 6, 21, 'moderate', '2025-12-12', NULL, 0, NULL),
(166, 6, 24, 'moderate', '2025-12-12', NULL, 0, NULL),
(167, 6, 4, 'mild', '2025-12-12', NULL, 0, NULL),
(168, 6, 1, 'mild', '2025-12-12', NULL, 0, NULL),
(169, 6, 10, 'severe', '2025-12-12', NULL, 0, NULL),
(170, 6, 23, 'mild', '2025-12-12', NULL, 0, NULL),
(171, 6, 25, 'severe', '2025-12-12', NULL, 0, NULL),
(172, 6, 6, 'mild', '2025-12-12', NULL, 0, NULL),
(173, 6, 7, 'mild', '2025-12-12', NULL, 0, NULL),
(174, 6, 5, 'moderate', '2025-12-12', NULL, 0, NULL),
(175, 6, 8, 'moderate', '2025-12-12', NULL, 0, NULL),
(176, 6, 26, 'mild', '2025-12-12', NULL, 0, NULL),
(209, 7, 2, 'moderate', NULL, NULL, 0, NULL),
(210, 7, 9, 'moderate', NULL, NULL, 0, NULL),
(211, 7, 3, 'mild', NULL, NULL, 0, NULL),
(212, 7, 22, 'mild', NULL, NULL, 0, NULL),
(213, 7, 21, 'mild', NULL, NULL, 0, NULL),
(214, 7, 24, 'mild', NULL, NULL, 0, NULL),
(215, 7, 4, 'severe', NULL, NULL, 0, NULL),
(216, 7, 1, 'mild', NULL, NULL, 0, NULL),
(217, 7, 10, 'moderate', NULL, NULL, 0, NULL),
(218, 7, 23, 'mild', NULL, NULL, 0, NULL),
(219, 7, 25, 'severe', NULL, NULL, 0, NULL),
(220, 7, 6, 'mild', NULL, NULL, 0, NULL),
(221, 7, 7, 'moderate', NULL, NULL, 0, NULL),
(222, 7, 5, 'mild', NULL, NULL, 0, NULL),
(223, 7, 8, 'moderate', NULL, NULL, 0, NULL),
(224, 7, 26, 'severe', NULL, NULL, 0, NULL),
(225, 8, 2, 'mild', NULL, NULL, 0, NULL),
(226, 8, 9, 'severe', NULL, NULL, 0, NULL),
(227, 8, 3, 'mild', NULL, NULL, 0, NULL),
(228, 8, 22, 'mild', NULL, NULL, 0, NULL),
(229, 8, 21, 'mild', NULL, NULL, 0, NULL),
(230, 8, 24, 'severe', NULL, NULL, 0, NULL),
(231, 8, 4, 'moderate', NULL, NULL, 0, NULL),
(232, 8, 1, 'mild', NULL, NULL, 0, NULL),
(233, 8, 10, 'mild', NULL, NULL, 0, NULL),
(234, 8, 23, 'severe', NULL, NULL, 0, NULL),
(235, 8, 25, 'moderate', NULL, NULL, 0, NULL),
(236, 8, 6, 'severe', NULL, NULL, 0, NULL),
(237, 8, 7, 'moderate', NULL, NULL, 0, NULL),
(238, 8, 5, 'mild', NULL, NULL, 0, NULL),
(239, 8, 8, 'mild', NULL, NULL, 0, NULL),
(240, 8, 26, 'mild', NULL, NULL, 0, NULL),
(241, 9, 2, 'severe', NULL, NULL, 0, NULL),
(242, 9, 9, 'mild', NULL, NULL, 0, NULL),
(243, 9, 3, 'mild', NULL, NULL, 0, NULL),
(244, 9, 22, 'mild', NULL, NULL, 0, NULL),
(245, 9, 21, 'mild', NULL, NULL, 0, NULL),
(246, 9, 24, 'mild', NULL, NULL, 0, NULL),
(247, 9, 4, 'mild', NULL, NULL, 0, NULL),
(248, 9, 1, 'mild', NULL, NULL, 0, NULL),
(249, 9, 10, 'mild', NULL, NULL, 0, NULL),
(250, 9, 23, 'mild', NULL, NULL, 0, NULL),
(251, 9, 25, 'mild', NULL, NULL, 0, NULL),
(252, 9, 6, 'moderate', NULL, NULL, 0, NULL),
(253, 9, 7, 'mild', NULL, NULL, 0, NULL),
(254, 9, 5, 'mild', NULL, NULL, 0, NULL),
(255, 9, 8, 'mild', NULL, NULL, 0, NULL),
(256, 9, 26, 'mild', NULL, NULL, 0, NULL),
(257, 10, 2, 'mild', NULL, NULL, 0, NULL),
(258, 10, 9, 'mild', NULL, NULL, 0, NULL),
(259, 10, 3, 'mild', NULL, NULL, 0, NULL),
(260, 10, 22, 'mild', NULL, NULL, 0, NULL),
(261, 10, 21, 'mild', NULL, NULL, 0, NULL),
(262, 10, 24, 'mild', NULL, NULL, 0, NULL),
(263, 10, 4, 'mild', NULL, NULL, 0, NULL),
(264, 10, 1, 'moderate', NULL, NULL, 0, NULL),
(265, 10, 10, 'mild', NULL, NULL, 0, NULL),
(266, 10, 23, 'moderate', NULL, NULL, 0, NULL),
(267, 10, 25, 'moderate', NULL, NULL, 0, NULL),
(268, 10, 6, 'mild', NULL, NULL, 0, NULL),
(269, 10, 7, 'mild', NULL, NULL, 0, NULL),
(270, 10, 5, 'moderate', NULL, NULL, 0, NULL),
(271, 10, 8, 'moderate', NULL, NULL, 0, NULL),
(272, 10, 26, 'moderate', NULL, NULL, 0, NULL),
(273, 11, 2, 'mild', NULL, NULL, 0, NULL),
(274, 11, 9, 'mild', NULL, NULL, 0, NULL),
(275, 11, 3, 'severe', NULL, NULL, 0, NULL),
(276, 11, 22, 'mild', NULL, NULL, 0, NULL),
(277, 11, 21, 'severe', NULL, NULL, 0, NULL),
(278, 11, 24, 'mild', NULL, NULL, 0, NULL),
(279, 11, 4, 'mild', NULL, NULL, 0, NULL),
(280, 11, 1, 'mild', NULL, NULL, 0, NULL),
(281, 11, 10, 'mild', NULL, NULL, 0, NULL),
(282, 11, 23, 'mild', NULL, NULL, 0, NULL),
(283, 11, 25, 'mild', NULL, NULL, 0, NULL),
(284, 11, 6, 'severe', NULL, NULL, 0, NULL),
(285, 11, 7, 'mild', NULL, NULL, 0, NULL),
(286, 11, 5, 'mild', NULL, NULL, 0, NULL),
(287, 11, 8, 'mild', NULL, NULL, 0, NULL),
(288, 11, 26, 'mild', NULL, NULL, 0, NULL),
(289, 12, 2, 'mild', NULL, NULL, 0, NULL),
(290, 12, 9, 'mild', NULL, NULL, 0, NULL),
(291, 12, 3, 'mild', NULL, NULL, 0, NULL),
(292, 12, 22, 'mild', NULL, NULL, 0, NULL),
(293, 12, 21, 'mild', NULL, NULL, 0, NULL),
(294, 12, 24, 'mild', NULL, NULL, 0, NULL),
(295, 12, 4, 'mild', NULL, NULL, 0, NULL),
(296, 12, 1, 'mild', NULL, NULL, 0, NULL),
(297, 12, 10, 'mild', NULL, NULL, 0, NULL),
(298, 12, 23, 'mild', NULL, NULL, 0, NULL),
(299, 12, 25, 'mild', NULL, NULL, 0, NULL),
(300, 12, 6, 'mild', NULL, NULL, 0, NULL),
(301, 12, 7, 'mild', NULL, NULL, 0, NULL),
(302, 12, 5, 'mild', NULL, NULL, 0, NULL),
(303, 12, 8, 'mild', NULL, NULL, 0, NULL),
(304, 12, 26, 'mild', NULL, NULL, 0, NULL),
(305, 13, 2, 'mild', NULL, NULL, 0, NULL),
(306, 13, 9, 'mild', NULL, NULL, 0, NULL),
(307, 13, 3, 'mild', NULL, NULL, 0, NULL),
(308, 13, 22, 'mild', NULL, NULL, 0, NULL),
(309, 13, 21, 'mild', NULL, NULL, 0, NULL),
(310, 13, 24, 'mild', NULL, NULL, 0, NULL),
(311, 13, 4, 'mild', NULL, NULL, 0, NULL),
(312, 13, 1, 'mild', NULL, NULL, 0, NULL),
(313, 13, 10, 'mild', NULL, NULL, 0, NULL),
(314, 13, 23, 'mild', NULL, NULL, 0, NULL),
(315, 13, 25, 'mild', NULL, NULL, 0, NULL),
(316, 13, 6, 'mild', NULL, NULL, 0, NULL),
(317, 13, 7, 'mild', NULL, NULL, 0, NULL),
(318, 13, 5, 'mild', NULL, NULL, 0, NULL),
(319, 13, 8, 'mild', NULL, NULL, 0, NULL),
(320, 13, 26, 'mild', NULL, NULL, 0, NULL),
(321, 14, 2, 'severe', NULL, NULL, 0, NULL),
(322, 14, 9, 'moderate', NULL, NULL, 0, NULL),
(323, 14, 3, 'mild', NULL, NULL, 0, NULL),
(324, 14, 22, 'mild', NULL, NULL, 0, NULL),
(325, 14, 21, 'mild', NULL, NULL, 0, NULL),
(326, 14, 24, 'mild', NULL, NULL, 0, NULL),
(327, 14, 4, 'mild', NULL, NULL, 0, NULL),
(328, 14, 1, 'mild', NULL, NULL, 0, NULL),
(329, 14, 10, 'mild', NULL, NULL, 0, NULL),
(330, 14, 23, 'severe', NULL, NULL, 0, NULL),
(331, 14, 25, 'mild', NULL, NULL, 0, NULL),
(332, 14, 6, 'mild', NULL, NULL, 0, NULL),
(333, 14, 7, 'mild', NULL, NULL, 0, NULL),
(334, 14, 5, 'mild', NULL, NULL, 0, NULL),
(335, 14, 8, 'mild', NULL, NULL, 0, NULL),
(336, 14, 26, 'mild', NULL, NULL, 0, NULL),
(337, 15, 2, 'moderate', NULL, NULL, 0, NULL),
(338, 15, 9, 'mild', NULL, NULL, 0, NULL),
(339, 15, 3, 'mild', NULL, NULL, 0, NULL),
(340, 15, 22, 'mild', NULL, NULL, 0, NULL),
(341, 15, 21, 'mild', NULL, NULL, 0, NULL),
(342, 15, 24, 'mild', NULL, NULL, 0, NULL),
(343, 15, 4, 'mild', NULL, NULL, 0, NULL),
(344, 15, 1, 'mild', NULL, NULL, 0, NULL),
(345, 15, 10, 'mild', NULL, NULL, 0, NULL),
(346, 15, 23, 'mild', NULL, NULL, 0, NULL),
(347, 15, 25, 'mild', NULL, NULL, 0, NULL),
(348, 15, 6, 'mild', NULL, NULL, 0, NULL),
(349, 15, 7, 'mild', NULL, NULL, 0, NULL),
(350, 15, 5, 'mild', NULL, NULL, 0, NULL),
(351, 15, 8, 'mild', NULL, NULL, 0, NULL),
(352, 15, 26, 'mild', NULL, NULL, 0, NULL),
(353, 16, 2, 'mild', NULL, NULL, 0, NULL),
(354, 16, 9, 'mild', NULL, NULL, 0, NULL),
(355, 16, 3, 'mild', NULL, NULL, 0, NULL),
(356, 16, 22, 'mild', NULL, NULL, 0, NULL),
(357, 16, 21, 'mild', NULL, NULL, 0, NULL),
(358, 16, 24, 'mild', NULL, NULL, 0, NULL),
(359, 16, 4, 'mild', NULL, NULL, 0, NULL),
(360, 16, 1, 'mild', NULL, NULL, 0, NULL),
(361, 16, 10, 'mild', NULL, NULL, 0, NULL),
(362, 16, 23, 'mild', NULL, NULL, 0, NULL),
(363, 16, 25, 'mild', NULL, NULL, 0, NULL),
(364, 16, 6, 'mild', NULL, NULL, 0, NULL),
(365, 16, 7, 'mild', NULL, NULL, 0, NULL),
(366, 16, 5, 'mild', NULL, NULL, 0, NULL),
(367, 16, 8, 'mild', NULL, NULL, 0, NULL),
(368, 16, 26, 'mild', NULL, NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_hair_profiles`
--

CREATE TABLE `user_hair_profiles` (
  `profile_id` int NOT NULL,
  `user_id` int NOT NULL,
  `hair_type_id` int DEFAULT NULL,
  `hair_density` enum('low','medium','high') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `hair_porosity` enum('low','medium','high') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `scalp_type` enum('dry','normal','oily','combination','sensitive') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `current_length` decimal(5,2) DEFAULT NULL,
  `goal_length` decimal(5,2) DEFAULT NULL,
  `hair_texture` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `elasticity` enum('low','normal','high') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_color_treated` tinyint(1) DEFAULT '0',
  `is_chemically_treated` tinyint(1) DEFAULT '0',
  `chemical_treatment_type` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `growth_goal` text COLLATE utf8mb4_general_ci,
  `growth_goal_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_hair_profiles`
--

INSERT INTO `user_hair_profiles` (`profile_id`, `user_id`, `hair_type_id`, `hair_density`, `hair_porosity`, `scalp_type`, `current_length`, `goal_length`, `hair_texture`, `elasticity`, `is_color_treated`, `is_chemically_treated`, `chemical_treatment_type`, `growth_goal`, `growth_goal_date`, `created_at`, `updated_at`) VALUES
(3, 2, 2, 'high', 'low', 'oily', 13.20, 20.00, 'Fine', 'low', 1, 0, NULL, NULL, NULL, '2025-12-12 21:29:53', '2025-12-12 21:31:36'),
(4, 3, 12, 'medium', 'medium', 'normal', 9.00, 20.00, 'Coarse', 'high', 0, 0, NULL, NULL, NULL, '2025-12-12 22:02:32', '2025-12-12 22:02:32'),
(5, 6, 5, 'low', 'low', 'combination', 38.00, 18.00, 'Praesentium est quae', 'high', 0, 0, 'Reprehenderit qui fu', NULL, NULL, '2025-12-12 23:34:51', '2025-12-12 23:34:51'),
(6, 4, 10, 'medium', 'high', 'dry', 11.00, 3.00, 'Eos non quidem et ma', 'normal', 1, 0, 'Sed pariatur Error', NULL, NULL, '2025-12-12 23:39:04', '2025-12-12 23:39:04'),
(7, 7, 10, 'medium', 'low', 'dry', 24.00, 97.00, 'Odio cum aliquam con', 'low', 1, 0, 'Ipsam repudiandae op', NULL, NULL, '2025-12-13 21:53:01', '2025-12-13 22:50:58'),
(8, 9, 9, 'high', 'high', 'dry', 42.00, 76.00, 'Vitae soluta est qui', 'high', 0, 1, 'Necessitatibus sit c', NULL, NULL, '2025-12-13 22:30:34', '2025-12-13 22:30:34'),
(9, 8, 9, 'low', 'medium', 'dry', 49.00, 78.00, 'Saepe in veritatis p', 'high', 0, 0, 'Labore nobis quia ut', NULL, NULL, '2025-12-13 22:31:05', '2025-12-13 22:31:05'),
(10, 10, 6, 'high', 'high', 'normal', 27.00, 24.00, 'Quo est sed in volu', 'normal', 0, 1, 'Aliqua Quia et aut', NULL, NULL, '2025-12-13 23:18:46', '2025-12-13 23:18:46'),
(11, 11, 11, 'high', 'low', 'oily', 38.80, 81.00, 'Sequi adipisicing no', 'high', 0, 0, 'Ad expedita possimus', NULL, NULL, '2025-12-13 23:19:09', '2025-12-13 23:26:40'),
(12, 12, 11, 'medium', 'medium', 'oily', 15.00, 30.00, 'Fine', 'normal', 0, 0, NULL, NULL, NULL, '2025-12-14 00:51:21', '2025-12-14 00:58:16'),
(13, 14, 12, 'low', 'low', 'oily', 2.00, 4.00, 'Coarse', 'normal', 1, 0, NULL, NULL, NULL, '2025-12-14 11:50:23', '2025-12-14 12:01:53'),
(14, 15, 1, 'medium', 'medium', 'dry', 12.00, 16.00, 'Medium', 'normal', 0, 1, 'Relaxer', NULL, NULL, '2025-12-14 13:36:38', '2025-12-14 13:36:38'),
(15, 16, 12, 'medium', 'medium', 'normal', 2.00, 15.00, 'Coarse', 'high', 0, 1, 'None', NULL, NULL, '2025-12-14 16:42:52', '2025-12-14 16:42:52'),
(16, 17, 12, 'medium', 'medium', 'normal', NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, '2025-12-14 21:00:24', '2025-12-14 21:00:24');

-- --------------------------------------------------------

--
-- Table structure for table `user_notifications`
--

CREATE TABLE `user_notifications` (
  `notification_id` int NOT NULL,
  `user_id` int NOT NULL,
  `notification_type` enum('routine_update','milestone_achieved','growth_forecast','diagnosis_follow_up','style_reminder','product_recommendation','general') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `title` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `message` text COLLATE utf8mb4_general_ci,
  `is_read` tinyint(1) DEFAULT '0',
  `action_url` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_recommendations`
--

CREATE TABLE `user_recommendations` (
  `recommendation_id` int NOT NULL,
  `profile_id` int NOT NULL,
  `recommendation_type` enum('product','method','pitfall_avoidance','general_tip','routine','style','treatment') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `method_id` int DEFAULT NULL,
  `pitfall_id` int DEFAULT NULL,
  `style_id` int DEFAULT NULL,
  `priority` enum('low','medium','high','critical') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `personalized_note` text COLLATE utf8mb4_general_ci,
  `reason_for_recommendation` text COLLATE utf8mb4_general_ci,
  `generated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_active` tinyint(1) DEFAULT '1',
  `user_dismissed` tinyint(1) DEFAULT '0',
  `age_consideration` text COLLATE utf8mb4_general_ci,
  `age_modified` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_recommendations`
--

INSERT INTO `user_recommendations` (`recommendation_id`, `profile_id`, `recommendation_type`, `product_id`, `method_id`, `pitfall_id`, `style_id`, `priority`, `personalized_note`, `reason_for_recommendation`, `generated_at`, `is_active`, `user_dismissed`, `age_consideration`, `age_modified`) VALUES
(60, 3, 'product', 1, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Good for 1B in small amounts', NULL, '2025-12-12 21:29:53', 1, 0, NULL, 0),
(61, 3, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Works for 1B', NULL, '2025-12-12 21:29:53', 1, 0, NULL, 0),
(62, 3, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Essential for 1B', NULL, '2025-12-12 21:29:53', 1, 0, NULL, 0),
(63, 3, 'method', NULL, 1, NULL, NULL, 'high', 'Effective method for your hair type. Great for 1B stimulation', NULL, '2025-12-12 21:29:53', 1, 0, NULL, 0),
(64, 3, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Good for 1B with proper technique', NULL, '2025-12-12 21:29:53', 1, 0, NULL, 0),
(65, 3, 'method', NULL, 4, NULL, NULL, 'medium', 'Effective method for your hair type. Good for 1B', NULL, '2025-12-12 21:29:53', 1, 0, NULL, 0),
(66, 3, 'method', NULL, 5, NULL, NULL, 'medium', 'Effective method for your hair type. Good for 1B maintenance', NULL, '2025-12-12 21:29:53', 1, 0, NULL, 0),
(67, 3, 'method', NULL, 6, NULL, NULL, 'medium', 'Effective method for your hair type. Moderate use for 1B', NULL, '2025-12-12 21:29:53', 1, 0, NULL, 0),
(71, 4, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Best for 4C, heavy moisture and growth promotion', NULL, '2025-12-12 22:08:48', 1, 0, NULL, 0),
(72, 4, 'product', 3, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Best for 4C hair', NULL, '2025-12-12 22:08:48', 1, 0, NULL, 0),
(73, 4, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Best for 4C', NULL, '2025-12-12 22:08:48', 1, 0, NULL, 0),
(74, 4, 'product', 7, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Very good for 4C detangling', NULL, '2025-12-12 22:08:48', 1, 0, NULL, 0),
(75, 4, 'product', 61, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Fetched from amazon', NULL, '2025-12-12 22:08:48', 1, 0, NULL, 0),
(76, 4, 'product', 62, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Fetched from amazon', NULL, '2025-12-12 22:08:48', 1, 0, NULL, 0),
(77, 4, 'product', 64, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Fetched from amazon', NULL, '2025-12-12 22:08:48', 1, 0, NULL, 0),
(78, 4, 'product', 65, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Fetched from ulta', NULL, '2025-12-12 22:08:48', 1, 0, NULL, 0),
(79, 4, 'product', 1, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Works for 4C, follow with intensive conditioning', NULL, '2025-12-12 22:08:48', 1, 0, NULL, 0),
(80, 4, 'product', 63, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Fetched from ulta', NULL, '2025-12-12 22:08:48', 1, 0, NULL, 0),
(81, 4, 'method', NULL, 1, NULL, NULL, 'high', 'Effective method for your hair type. Essential for 4C, use heavier oils Age-specific: Standard technique works well Precautions: Consistency is key', NULL, '2025-12-12 22:08:48', 1, 0, '0', 0),
(82, 4, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Very important for 4C growth Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-12 22:08:48', 1, 0, '0', 0),
(83, 4, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Non-negotiable for 4C hair Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-12 22:08:48', 1, 0, '0', 0),
(84, 4, 'method', NULL, 5, NULL, NULL, 'medium', 'Effective method for your hair type. Essential for 4C length retention', NULL, '2025-12-12 22:08:48', 1, 0, NULL, 0),
(85, 4, 'method', NULL, 4, NULL, NULL, 'medium', 'Effective method for your hair type. Absolutely necessary for 4C', NULL, '2025-12-12 22:08:48', 1, 0, NULL, 0),
(86, 4, 'method', NULL, 6, NULL, NULL, 'medium', 'Effective method for your hair type. Best for 4C', NULL, '2025-12-12 22:08:48', 1, 0, NULL, 0),
(87, 4, 'pitfall_avoidance', NULL, NULL, 1, NULL, 'critical', 'Important to avoid for your hair type. 4C hair extremely prone to heat damage', NULL, '2025-12-12 22:08:48', 1, 0, '0', 0),
(88, 4, 'pitfall_avoidance', NULL, NULL, 3, NULL, 'critical', 'Important to avoid for your hair type. Extremely high risk, edges very fragile', NULL, '2025-12-12 22:08:48', 1, 0, '0', 0),
(89, 4, 'pitfall_avoidance', NULL, NULL, 6, NULL, 'critical', 'Important to avoid for your hair type. 4C most fragile when wet, avoid brushing', NULL, '2025-12-12 22:08:48', 1, 0, '0', 0),
(90, 4, 'pitfall_avoidance', NULL, NULL, 5, NULL, 'high', 'Important to avoid for your hair type. Extremely harsh on 4C hair', NULL, '2025-12-12 22:08:48', 1, 0, '0', 0),
(91, 5, 'product', 1, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Excellent for 2B Gentle enough for children with natural ingredients', NULL, '2025-12-12 23:34:51', 0, 0, '0', 0),
(92, 5, 'product', 3, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Good for 2B hair Gentle enough for children with natural ingredients', NULL, '2025-12-12 23:34:51', 0, 0, '0', 0),
(93, 5, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Good for 2B Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL, '2025-12-12 23:34:51', 0, 0, '0', 1),
(94, 5, 'product', 2, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Good for 2B but use sparingly Gentle enough for children with natural ingredients', NULL, '2025-12-12 23:34:51', 0, 0, '0', 0),
(95, 5, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Essential for 2B Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-12 23:34:51', 0, 0, '0', 0),
(96, 5, 'method', NULL, 1, NULL, NULL, 'high', 'Effective method for your hair type. Great for 2B Age-specific: Use very gentle pressure, make it fun and relaxing Precautions: Always gentle, never forceful', NULL, '2025-12-12 23:34:51', 0, 0, '0', 0),
(97, 5, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Great for 2B Age-specific: Only very loose styles, frequent breaks needed Precautions: NEVER tight styles - developing follicles are fragile', NULL, '2025-12-12 23:34:51', 0, 0, '0', 0),
(98, 5, 'method', NULL, 4, NULL, NULL, 'medium', 'Effective method for your hair type. Very helpful for 2B', NULL, '2025-12-12 23:34:51', 0, 0, NULL, 0),
(99, 5, 'method', NULL, 5, NULL, NULL, 'medium', 'Effective method for your hair type. Very good for 2B', NULL, '2025-12-12 23:34:51', 0, 0, NULL, 0),
(100, 5, 'method', NULL, 6, NULL, NULL, 'medium', 'Effective method for your hair type. Great for 2B', NULL, '2025-12-12 23:34:51', 0, 0, NULL, 0),
(101, 5, 'product', 1, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Excellent for 2B Gentle enough for children with natural ingredients', NULL, '2025-12-12 23:34:58', 0, 0, '0', 0),
(102, 5, 'product', 3, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Good for 2B hair Gentle enough for children with natural ingredients', NULL, '2025-12-12 23:34:58', 0, 0, '0', 0),
(103, 5, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Good for 2B Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL, '2025-12-12 23:34:58', 0, 0, '0', 1),
(104, 5, 'product', 2, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Good for 2B but use sparingly Gentle enough for children with natural ingredients', NULL, '2025-12-12 23:34:58', 0, 0, '0', 0),
(105, 5, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Essential for 2B Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-12 23:34:58', 0, 0, '0', 0),
(106, 5, 'method', NULL, 1, NULL, NULL, 'high', 'Effective method for your hair type. Great for 2B Age-specific: Use very gentle pressure, make it fun and relaxing Precautions: Always gentle, never forceful', NULL, '2025-12-12 23:34:58', 0, 0, '0', 0),
(107, 5, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Great for 2B Age-specific: Only very loose styles, frequent breaks needed Precautions: NEVER tight styles - developing follicles are fragile', NULL, '2025-12-12 23:34:58', 0, 0, '0', 0),
(108, 5, 'method', NULL, 4, NULL, NULL, 'medium', 'Effective method for your hair type. Very helpful for 2B', NULL, '2025-12-12 23:34:58', 0, 0, NULL, 0),
(109, 5, 'method', NULL, 5, NULL, NULL, 'medium', 'Effective method for your hair type. Very good for 2B', NULL, '2025-12-12 23:34:58', 0, 0, NULL, 0),
(110, 5, 'method', NULL, 6, NULL, NULL, 'medium', 'Effective method for your hair type. Great for 2B', NULL, '2025-12-12 23:34:58', 0, 0, NULL, 0),
(111, 5, 'product', 1, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Excellent for 2B Gentle enough for children with natural ingredients', NULL, '2025-12-12 23:35:28', 0, 0, '0', 0),
(112, 5, 'product', 3, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Good for 2B hair Gentle enough for children with natural ingredients', NULL, '2025-12-12 23:35:28', 0, 0, '0', 0),
(113, 5, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Good for 2B Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL, '2025-12-12 23:35:28', 0, 0, '0', 1),
(114, 5, 'product', 2, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Good for 2B but use sparingly Gentle enough for children with natural ingredients', NULL, '2025-12-12 23:35:28', 0, 0, '0', 0),
(115, 5, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Essential for 2B Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-12 23:35:28', 0, 0, '0', 0),
(116, 5, 'method', NULL, 1, NULL, NULL, 'high', 'Effective method for your hair type. Great for 2B Age-specific: Use very gentle pressure, make it fun and relaxing Precautions: Always gentle, never forceful', NULL, '2025-12-12 23:35:28', 0, 0, '0', 0),
(117, 5, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Great for 2B Age-specific: Only very loose styles, frequent breaks needed Precautions: NEVER tight styles - developing follicles are fragile', NULL, '2025-12-12 23:35:28', 0, 0, '0', 0),
(118, 5, 'method', NULL, 4, NULL, NULL, 'medium', 'Effective method for your hair type. Very helpful for 2B', NULL, '2025-12-12 23:35:28', 0, 0, NULL, 0),
(119, 5, 'method', NULL, 5, NULL, NULL, 'medium', 'Effective method for your hair type. Very good for 2B', NULL, '2025-12-12 23:35:28', 0, 0, NULL, 0),
(120, 5, 'method', NULL, 6, NULL, NULL, 'medium', 'Effective method for your hair type. Great for 2B', NULL, '2025-12-12 23:35:28', 0, 0, NULL, 0),
(121, 5, 'product', 1, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Excellent for 2B Gentle enough for children with natural ingredients', NULL, '2025-12-12 23:35:38', 0, 0, '0', 0),
(122, 5, 'product', 3, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Good for 2B hair Gentle enough for children with natural ingredients', NULL, '2025-12-12 23:35:38', 0, 0, '0', 0),
(123, 5, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Good for 2B Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL, '2025-12-12 23:35:38', 0, 0, '0', 1),
(124, 5, 'product', 2, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Good for 2B but use sparingly Gentle enough for children with natural ingredients', NULL, '2025-12-12 23:35:38', 0, 0, '0', 0),
(125, 5, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Essential for 2B Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-12 23:35:38', 0, 0, '0', 0),
(126, 5, 'method', NULL, 1, NULL, NULL, 'high', 'Effective method for your hair type. Great for 2B Age-specific: Use very gentle pressure, make it fun and relaxing Precautions: Always gentle, never forceful', NULL, '2025-12-12 23:35:38', 0, 0, '0', 0),
(127, 5, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Great for 2B Age-specific: Only very loose styles, frequent breaks needed Precautions: NEVER tight styles - developing follicles are fragile', NULL, '2025-12-12 23:35:38', 0, 0, '0', 0),
(128, 5, 'method', NULL, 4, NULL, NULL, 'medium', 'Effective method for your hair type. Very helpful for 2B', NULL, '2025-12-12 23:35:38', 0, 0, NULL, 0),
(129, 5, 'method', NULL, 5, NULL, NULL, 'medium', 'Effective method for your hair type. Very good for 2B', NULL, '2025-12-12 23:35:38', 0, 0, NULL, 0),
(130, 5, 'method', NULL, 6, NULL, NULL, 'medium', 'Effective method for your hair type. Great for 2B', NULL, '2025-12-12 23:35:38', 0, 0, NULL, 0),
(131, 5, 'product', 1, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Excellent for 2B Gentle enough for children with natural ingredients', NULL, '2025-12-12 23:38:30', 1, 0, '0', 0),
(132, 5, 'product', 3, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Good for 2B hair Gentle enough for children with natural ingredients', NULL, '2025-12-12 23:38:30', 1, 0, '0', 0),
(133, 5, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Good for 2B Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL, '2025-12-12 23:38:30', 1, 0, '0', 1),
(134, 5, 'product', 2, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Good for 2B but use sparingly Gentle enough for children with natural ingredients', NULL, '2025-12-12 23:38:30', 1, 0, '0', 0),
(135, 5, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Essential for 2B Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-12 23:38:30', 1, 0, '0', 0),
(136, 5, 'method', NULL, 1, NULL, NULL, 'high', 'Effective method for your hair type. Great for 2B Age-specific: Use very gentle pressure, make it fun and relaxing Precautions: Always gentle, never forceful', NULL, '2025-12-12 23:38:30', 1, 0, '0', 0),
(137, 5, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Great for 2B Age-specific: Only very loose styles, frequent breaks needed Precautions: NEVER tight styles - developing follicles are fragile', NULL, '2025-12-12 23:38:30', 1, 0, '0', 0),
(138, 5, 'method', NULL, 4, NULL, NULL, 'medium', 'Effective method for your hair type. Very helpful for 2B', NULL, '2025-12-12 23:38:30', 1, 0, NULL, 0),
(139, 5, 'method', NULL, 5, NULL, NULL, 'medium', 'Effective method for your hair type. Very good for 2B', NULL, '2025-12-12 23:38:30', 1, 0, NULL, 0),
(140, 5, 'method', NULL, 6, NULL, NULL, 'medium', 'Effective method for your hair type. Great for 2B', NULL, '2025-12-12 23:38:30', 1, 0, NULL, 0),
(141, 6, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Perfect for 4A, great moisture sealant', NULL, '2025-12-12 23:39:04', 1, 0, NULL, 0),
(142, 6, 'product', 7, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Ideal for 4A hair', NULL, '2025-12-12 23:39:04', 1, 0, NULL, 0),
(143, 6, 'product', 3, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Ideal for 4A', NULL, '2025-12-12 23:39:04', 1, 0, NULL, 0),
(144, 6, 'product', 4, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Ideal for 4A', NULL, '2025-12-12 23:39:04', 1, 0, NULL, 0),
(145, 6, 'product', 2, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Works wonderfully for 4A hair', NULL, '2025-12-12 23:39:04', 1, 0, NULL, 0),
(146, 6, 'product', 1, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Good for 4A, might need additional moisture after', NULL, '2025-12-12 23:39:04', 1, 0, NULL, 0),
(147, 6, 'method', NULL, 1, NULL, NULL, 'high', 'Effective method for your hair type. Perfect for 4A hair, highly recommended Age-specific: Standard technique works well Precautions: Consistency is key', NULL, '2025-12-12 23:39:04', 1, 0, '0', 0),
(148, 6, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Highly effective for 4A Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-12 23:39:04', 1, 0, '0', 0),
(149, 6, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Absolutely necessary for 4A Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-12 23:39:04', 1, 0, '0', 0),
(150, 6, 'method', NULL, 5, NULL, NULL, 'medium', 'Effective method for your hair type. Excellent for 4A hair', NULL, '2025-12-12 23:39:04', 1, 0, NULL, 0),
(151, 6, 'method', NULL, 4, NULL, NULL, 'medium', 'Effective method for your hair type. Critical for 4A', NULL, '2025-12-12 23:39:04', 1, 0, NULL, 0),
(152, 6, 'method', NULL, 6, NULL, NULL, 'medium', 'Effective method for your hair type. Ideal for 4A', NULL, '2025-12-12 23:39:04', 1, 0, NULL, 0),
(153, 6, 'pitfall_avoidance', NULL, NULL, 1, NULL, 'critical', 'Important to avoid for your hair type. Coily hair is most vulnerable to heat damage', NULL, '2025-12-12 23:39:04', 1, 0, '0', 0),
(154, 6, 'pitfall_avoidance', NULL, NULL, 6, NULL, 'critical', 'Important to avoid for your hair type. Extremely fragile when wet', NULL, '2025-12-12 23:39:04', 1, 0, '0', 0),
(155, 6, 'pitfall_avoidance', NULL, NULL, 3, NULL, 'high', 'Important to avoid for your hair type. High risk of traction alopecia', NULL, '2025-12-12 23:39:04', 1, 0, '0', 0),
(156, 6, 'pitfall_avoidance', NULL, NULL, 5, NULL, 'high', 'Important to avoid for your hair type. Very drying for coily hair', NULL, '2025-12-12 23:39:04', 1, 0, '0', 0),
(157, 7, 'product', 3, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Ideal for 4A Excellent for mature hair - provides needed moisture and gentle care', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(158, 7, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Perfect for 4A, great moisture sealant', NULL, '2025-12-13 21:57:19', 1, 0, NULL, 0),
(159, 7, 'product', 7, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Ideal for 4A hair', NULL, '2025-12-13 21:57:19', 1, 0, NULL, 0),
(160, 7, 'product', 4, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Ideal for 4A', NULL, '2025-12-13 21:57:19', 1, 0, NULL, 0),
(161, 7, 'product', 2, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Works wonderfully for 4A hair', NULL, '2025-12-13 21:57:19', 1, 0, NULL, 0),
(162, 7, 'product', 1, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Good for 4A, might need additional moisture after Excellent for mature hair - provides needed moisture and gentle care', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(163, 7, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Absolutely necessary for 4A Age-specific: Non-negotiable for hair health Precautions: Focus on moisture, gentle heat', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(164, 7, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Absolutely necessary for 4A Age-specific: Non-negotiable for hair health Precautions: Focus on moisture, gentle heat', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(165, 7, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Absolutely necessary for 4A Age-specific: Non-negotiable for hair health Precautions: Focus on moisture, gentle heat', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(166, 7, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Absolutely necessary for 4A Age-specific: Non-negotiable for hair health Precautions: Focus on moisture, gentle heat', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(167, 7, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Absolutely necessary for 4A Age-specific: Non-negotiable for hair health Precautions: Focus on moisture, gentle heat', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(168, 7, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Absolutely necessary for 4A Age-specific: Non-negotiable for hair health Precautions: Focus on moisture, gentle heat', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(169, 7, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Absolutely necessary for 4A Age-specific: Non-negotiable for hair health Precautions: Focus on moisture, gentle heat', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(170, 7, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Absolutely necessary for 4A Age-specific: Non-negotiable for hair health Precautions: Focus on moisture, gentle heat', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(171, 7, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Absolutely necessary for 4A Age-specific: Non-negotiable for hair health Precautions: Focus on moisture, gentle heat', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(172, 7, 'method', NULL, 1, NULL, NULL, 'low', 'Effective method for your hair type. Perfect for 4A hair, highly recommended Age-specific: Essential for scalp health, use gentle pressure Precautions: Be extremely gentle, scalp is more sensitive', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(173, 7, 'pitfall_avoidance', NULL, NULL, 1, NULL, 'critical', 'Important to avoid for your hair type. Coily hair is most vulnerable to heat damage', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(174, 7, 'pitfall_avoidance', NULL, NULL, 6, NULL, 'critical', 'Important to avoid for your hair type. Extremely fragile when wet', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(175, 7, 'pitfall_avoidance', NULL, NULL, 1, NULL, 'critical', 'Important to avoid for your hair type. Coily hair is most vulnerable to heat damage', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(176, 7, 'pitfall_avoidance', NULL, NULL, 6, NULL, 'critical', 'Important to avoid for your hair type. Extremely fragile when wet', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(177, 7, 'pitfall_avoidance', NULL, NULL, 1, NULL, 'critical', 'Important to avoid for your hair type. Coily hair is most vulnerable to heat damage', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(178, 7, 'pitfall_avoidance', NULL, NULL, 6, NULL, 'critical', 'Important to avoid for your hair type. Extremely fragile when wet', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(179, 7, 'pitfall_avoidance', NULL, NULL, 3, NULL, 'high', 'Important to avoid for your hair type. High risk of traction alopecia', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(180, 7, 'pitfall_avoidance', NULL, NULL, 5, NULL, 'high', 'Important to avoid for your hair type. Very drying for coily hair', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(181, 7, 'pitfall_avoidance', NULL, NULL, 3, NULL, 'high', 'Important to avoid for your hair type. High risk of traction alopecia', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(182, 7, 'pitfall_avoidance', NULL, NULL, 5, NULL, 'high', 'Important to avoid for your hair type. Very drying for coily hair', NULL, '2025-12-13 21:57:19', 1, 0, '0', 0),
(183, 8, 'product', 3, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Perfect for 3C Gentle enough for children with natural ingredients', NULL, '2025-12-13 22:30:34', 1, 0, '0', 0),
(184, 8, 'product', 7, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Perfect for 3C detangling Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL, '2025-12-13 22:30:34', 1, 0, '0', 1),
(185, 8, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Perfect for 3C Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL, '2025-12-13 22:30:34', 1, 0, '0', 1),
(186, 8, 'product', 1, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Works well for 3C, gentle cleansing without stripping Gentle enough for children with natural ingredients', NULL, '2025-12-13 22:30:34', 1, 0, '0', 0),
(187, 8, 'product', 2, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Great for 3C, provides moisture and definition Gentle enough for children with natural ingredients', NULL, '2025-12-13 22:30:34', 1, 0, '0', 0),
(188, 8, 'product', 4, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Excellent for 3C hair Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL, '2025-12-13 22:30:34', 1, 0, '0', 1),
(189, 8, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:30:34', 1, 0, '0', 0),
(190, 8, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:30:34', 1, 0, '0', 0),
(191, 8, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:30:34', 1, 0, '0', 0),
(192, 8, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:30:34', 1, 0, '0', 0),
(193, 8, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:30:34', 1, 0, '0', 0),
(194, 8, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:30:34', 1, 0, '0', 0),
(195, 8, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:30:34', 1, 0, '0', 0),
(196, 8, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:30:34', 1, 0, '0', 0),
(197, 8, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:30:34', 1, 0, '0', 0),
(198, 8, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:30:34', 1, 0, '0', 0),
(199, 9, 'product', 3, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Perfect for 3C Gentle enough for children with natural ingredients', NULL, '2025-12-13 22:31:05', 1, 0, '0', 0),
(200, 9, 'product', 7, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Perfect for 3C detangling Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL, '2025-12-13 22:31:05', 1, 0, '0', 1),
(201, 9, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Perfect for 3C Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL, '2025-12-13 22:31:05', 1, 0, '0', 1),
(202, 9, 'product', 1, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Works well for 3C, gentle cleansing without stripping Gentle enough for children with natural ingredients', NULL, '2025-12-13 22:31:05', 1, 0, '0', 0),
(203, 9, 'product', 2, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Great for 3C, provides moisture and definition Gentle enough for children with natural ingredients', NULL, '2025-12-13 22:31:05', 1, 0, '0', 0),
(204, 9, 'product', 4, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Excellent for 3C hair Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL, '2025-12-13 22:31:05', 1, 0, '0', 1),
(205, 9, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:31:05', 1, 0, '0', 0),
(206, 9, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:31:05', 1, 0, '0', 0),
(207, 9, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:31:05', 1, 0, '0', 0),
(208, 9, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:31:05', 1, 0, '0', 0),
(209, 9, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:31:05', 1, 0, '0', 0),
(210, 9, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:31:05', 1, 0, '0', 0),
(211, 9, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:31:05', 1, 0, '0', 0),
(212, 9, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:31:05', 1, 0, '0', 0),
(213, 9, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:31:05', 1, 0, '0', 0),
(214, 9, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Vital for 3C health Age-specific: Gentle, moisture-based only, no protein Precautions: Avoid heat, shorter duration', NULL, '2025-12-13 22:31:05', 1, 0, '0', 0),
(215, 10, 'product', 1, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Great for 2C hair Excellent for mature hair - provides needed moisture and gentle care', NULL, '2025-12-13 23:18:46', 1, 0, '0', 0),
(216, 10, 'product', 3, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Excellent for 2C Excellent for mature hair - provides needed moisture and gentle care', NULL, '2025-12-13 23:18:46', 1, 0, '0', 0),
(217, 10, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Excellent for 2C', NULL, '2025-12-13 23:18:46', 1, 0, NULL, 0),
(218, 10, 'product', 2, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Works well for 2C', NULL, '2025-12-13 23:18:46', 1, 0, NULL, 0),
(219, 10, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Critical for 2C Age-specific: Non-negotiable for hair health Precautions: Focus on moisture, gentle heat', NULL, '2025-12-13 23:18:46', 1, 0, '0', 0),
(220, 10, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Critical for 2C Age-specific: Non-negotiable for hair health Precautions: Focus on moisture, gentle heat', NULL, '2025-12-13 23:18:46', 1, 0, '0', 0),
(221, 10, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Critical for 2C Age-specific: Non-negotiable for hair health Precautions: Focus on moisture, gentle heat', NULL, '2025-12-13 23:18:46', 1, 0, '0', 0),
(222, 10, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Critical for 2C Age-specific: Non-negotiable for hair health Precautions: Focus on moisture, gentle heat', NULL, '2025-12-13 23:18:46', 1, 0, '0', 0),
(223, 10, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Critical for 2C Age-specific: Non-negotiable for hair health Precautions: Focus on moisture, gentle heat', NULL, '2025-12-13 23:18:46', 1, 0, '0', 0),
(224, 10, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Critical for 2C Age-specific: Non-negotiable for hair health Precautions: Focus on moisture, gentle heat', NULL, '2025-12-13 23:18:46', 1, 0, '0', 0),
(225, 10, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Critical for 2C Age-specific: Non-negotiable for hair health Precautions: Focus on moisture, gentle heat', NULL, '2025-12-13 23:18:46', 1, 0, '0', 0),
(226, 10, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Critical for 2C Age-specific: Non-negotiable for hair health Precautions: Focus on moisture, gentle heat', NULL, '2025-12-13 23:18:46', 1, 0, '0', 0),
(227, 10, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Critical for 2C Age-specific: Non-negotiable for hair health Precautions: Focus on moisture, gentle heat', NULL, '2025-12-13 23:18:46', 1, 0, '0', 0),
(228, 10, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Critical for 2C Age-specific: Non-negotiable for hair health Precautions: Focus on moisture, gentle heat', NULL, '2025-12-13 23:18:46', 1, 0, '0', 0),
(229, 11, 'product', 3, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Excellent for 4B Gentle enough for children with natural ingredients', NULL, '2025-12-13 23:19:09', 1, 0, '0', 0),
(230, 11, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Ideal for 4B, excellent for growth Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL, '2025-12-13 23:19:09', 1, 0, '0', 1),
(231, 11, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Excellent for 4B Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL, '2025-12-13 23:19:09', 1, 0, '0', 1),
(232, 11, 'product', 7, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Great for 4B, excellent slip Use with caution, may be too harsh for developing hair **PARENT SUPERVISION REQUIRED** - This product should only be used with active parent supervision and guidance.', NULL, '2025-12-13 23:19:09', 1, 0, '0', 1),
(233, 11, 'product', 1, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Suitable for 4B, pair with rich conditioner Gentle enough for children with natural ingredients', NULL, '2025-12-13 23:19:09', 1, 0, '0', 0),
(234, 11, 'product', 2, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Good for 4B, may need additional sealant Gentle enough for children with natural ingredients', NULL, '2025-12-13 23:19:09', 1, 0, '0', 0),
(235, 11, 'method', NULL, 1, NULL, NULL, 'high', 'Effective method for your hair type. Ideal for 4B, crucial for moisture Age-specific: Use very gentle pressure, make it fun and relaxing Precautions: Always gentle, never forceful', NULL, '2025-12-13 23:19:09', 1, 0, '0', 0),
(236, 11, 'method', NULL, 1, NULL, NULL, 'high', 'Effective method for your hair type. Ideal for 4B, crucial for moisture Age-specific: Use very gentle pressure, make it fun and relaxing Precautions: Always gentle, never forceful', NULL, '2025-12-13 23:19:09', 1, 0, '0', 0),
(237, 11, 'method', NULL, 1, NULL, NULL, 'high', 'Effective method for your hair type. Ideal for 4B, crucial for moisture Age-specific: Use very gentle pressure, make it fun and relaxing Precautions: Always gentle, never forceful', NULL, '2025-12-13 23:19:09', 1, 0, '0', 0),
(238, 11, 'method', NULL, 1, NULL, NULL, 'medium', 'Effective method for your hair type. Ideal for 4B, crucial for moisture Age-specific: Use very gentle pressure, make it fun and relaxing Precautions: Always gentle, never forceful', NULL, '2025-12-13 23:19:09', 1, 0, '0', 0),
(239, 11, 'method', NULL, 1, NULL, NULL, 'medium', 'Effective method for your hair type. Ideal for 4B, crucial for moisture Age-specific: Use very gentle pressure, make it fun and relaxing Precautions: Always gentle, never forceful', NULL, '2025-12-13 23:19:09', 1, 0, '0', 0),
(240, 11, 'method', NULL, 1, NULL, NULL, 'medium', 'Effective method for your hair type. Ideal for 4B, crucial for moisture Age-specific: Use very gentle pressure, make it fun and relaxing Precautions: Always gentle, never forceful', NULL, '2025-12-13 23:19:09', 1, 0, '0', 0),
(241, 11, 'method', NULL, 1, NULL, NULL, 'low', 'Effective method for your hair type. Ideal for 4B, crucial for moisture Age-specific: Use very gentle pressure, make it fun and relaxing Precautions: Always gentle, never forceful', NULL, '2025-12-13 23:19:09', 1, 0, '0', 0),
(242, 11, 'method', NULL, 1, NULL, NULL, 'low', 'Effective method for your hair type. Ideal for 4B, crucial for moisture Age-specific: Use very gentle pressure, make it fun and relaxing Precautions: Always gentle, never forceful', NULL, '2025-12-13 23:19:09', 1, 0, '0', 0),
(243, 11, 'method', NULL, 1, NULL, NULL, 'low', 'Effective method for your hair type. Ideal for 4B, crucial for moisture Age-specific: Use very gentle pressure, make it fun and relaxing Precautions: Always gentle, never forceful', NULL, '2025-12-13 23:19:09', 1, 0, '0', 0),
(244, 11, 'method', NULL, 1, NULL, NULL, 'low', 'Effective method for your hair type. Ideal for 4B, crucial for moisture Age-specific: Use very gentle pressure, make it fun and relaxing Precautions: Always gentle, never forceful', NULL, '2025-12-13 23:19:09', 1, 0, '0', 0),
(245, 12, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Ideal for 4B, excellent for growth', NULL, '2025-12-14 00:51:21', 0, 0, NULL, 0),
(246, 12, 'product', 3, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Excellent for 4B', NULL, '2025-12-14 00:51:21', 0, 0, NULL, 0),
(247, 12, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Excellent for 4B', NULL, '2025-12-14 00:51:21', 0, 0, NULL, 0),
(248, 12, 'product', 7, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Great for 4B, excellent slip', NULL, '2025-12-14 00:51:21', 0, 0, NULL, 0),
(249, 12, 'product', 1, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Suitable for 4B, pair with rich conditioner', NULL, '2025-12-14 00:51:21', 0, 0, NULL, 0),
(250, 12, 'product', 2, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Good for 4B, may need additional sealant', NULL, '2025-12-14 00:51:21', 0, 0, NULL, 0),
(251, 12, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Critical for 4B moisture Age-specific: Excellent habit to establish Precautions: Adjust based on activity level', NULL, '2025-12-14 00:51:21', 0, 0, '0', 0),
(252, 12, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Critical for 4B moisture Age-specific: Excellent habit to establish Precautions: Adjust based on activity level', NULL, '2025-12-14 00:51:21', 0, 0, '0', 0),
(253, 12, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Critical for 4B moisture Age-specific: Excellent habit to establish Precautions: Adjust based on activity level', NULL, '2025-12-14 00:51:21', 0, 0, '0', 0),
(254, 12, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Critical for 4B moisture Age-specific: Excellent habit to establish Precautions: Adjust based on activity level', NULL, '2025-12-14 00:51:21', 0, 0, '0', 0),
(255, 12, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Critical for 4B moisture Age-specific: Excellent habit to establish Precautions: Adjust based on activity level', NULL, '2025-12-14 00:51:21', 0, 0, '0', 0),
(256, 12, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Critical for 4B moisture Age-specific: Excellent habit to establish Precautions: Adjust based on activity level', NULL, '2025-12-14 00:51:21', 0, 0, '0', 0),
(257, 12, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Critical for 4B moisture Age-specific: Excellent habit to establish Precautions: Adjust based on activity level', NULL, '2025-12-14 00:51:21', 0, 0, '0', 0),
(258, 12, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Critical for 4B moisture Age-specific: Excellent habit to establish Precautions: Adjust based on activity level', NULL, '2025-12-14 00:51:21', 0, 0, '0', 0),
(259, 12, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Critical for 4B moisture Age-specific: Excellent habit to establish Precautions: Adjust based on activity level', NULL, '2025-12-14 00:51:21', 0, 0, '0', 0),
(260, 12, 'method', NULL, 1, NULL, NULL, 'low', 'Effective method for your hair type. Ideal for 4B, crucial for moisture Age-specific: Can increase pressure slightly, good stress relief Precautions: Teach proper technique', NULL, '2025-12-14 00:51:21', 0, 0, '0', 0),
(261, 12, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Ideal for 4B, excellent for growth', NULL, '2025-12-14 00:55:20', 1, 0, NULL, 0),
(262, 12, 'product', 3, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Excellent for 4B', NULL, '2025-12-14 00:55:20', 1, 0, NULL, 0),
(263, 12, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Excellent for 4B', NULL, '2025-12-14 00:55:20', 1, 0, NULL, 0),
(264, 12, 'product', 7, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Great for 4B, excellent slip', NULL, '2025-12-14 00:55:20', 1, 0, NULL, 0),
(265, 12, 'product', 61, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Fetched from amazon', NULL, '2025-12-14 00:55:20', 1, 0, NULL, 0),
(266, 12, 'product', 62, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Fetched from amazon', NULL, '2025-12-14 00:55:20', 1, 0, NULL, 0),
(267, 12, 'product', 64, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Fetched from amazon', NULL, '2025-12-14 00:55:20', 1, 0, NULL, 0),
(268, 12, 'product', 65, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Fetched from ulta', NULL, '2025-12-14 00:55:20', 1, 0, NULL, 0),
(269, 12, 'product', 1, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Suitable for 4B, pair with rich conditioner', NULL, '2025-12-14 00:55:20', 1, 0, NULL, 0),
(270, 12, 'product', 2, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Good for 4B, may need additional sealant', NULL, '2025-12-14 00:55:20', 1, 0, NULL, 0),
(271, 12, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Critical for 4B moisture Age-specific: Excellent habit to establish Precautions: Adjust based on activity level', NULL, '2025-12-14 00:55:20', 1, 0, '0', 0),
(272, 12, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Critical for 4B moisture Age-specific: Excellent habit to establish Precautions: Adjust based on activity level', NULL, '2025-12-14 00:55:20', 1, 0, '0', 0),
(273, 12, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Critical for 4B moisture Age-specific: Excellent habit to establish Precautions: Adjust based on activity level', NULL, '2025-12-14 00:55:20', 1, 0, '0', 0),
(274, 12, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Critical for 4B moisture Age-specific: Excellent habit to establish Precautions: Adjust based on activity level', NULL, '2025-12-14 00:55:20', 1, 0, '0', 0),
(275, 12, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Critical for 4B moisture Age-specific: Excellent habit to establish Precautions: Adjust based on activity level', NULL, '2025-12-14 00:55:20', 1, 0, '0', 0),
(276, 12, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Critical for 4B moisture Age-specific: Excellent habit to establish Precautions: Adjust based on activity level', NULL, '2025-12-14 00:55:20', 1, 0, '0', 0),
(277, 12, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Critical for 4B moisture Age-specific: Excellent habit to establish Precautions: Adjust based on activity level', NULL, '2025-12-14 00:55:20', 1, 0, '0', 0),
(278, 12, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Critical for 4B moisture Age-specific: Excellent habit to establish Precautions: Adjust based on activity level', NULL, '2025-12-14 00:55:20', 1, 0, '0', 0),
(279, 12, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Critical for 4B moisture Age-specific: Excellent habit to establish Precautions: Adjust based on activity level', NULL, '2025-12-14 00:55:20', 1, 0, '0', 0),
(280, 12, 'method', NULL, 1, NULL, NULL, 'low', 'Effective method for your hair type. Ideal for 4B, crucial for moisture Age-specific: Can increase pressure slightly, good stress relief Precautions: Teach proper technique', NULL, '2025-12-14 00:55:20', 1, 0, '0', 0),
(281, 13, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Best for 4C, heavy moisture and growth promotion', NULL, '2025-12-14 11:50:23', 1, 0, NULL, 0),
(282, 13, 'product', 3, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Best for 4C hair', NULL, '2025-12-14 11:50:23', 1, 0, NULL, 0),
(283, 13, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Best for 4C', NULL, '2025-12-14 11:50:23', 1, 0, NULL, 0),
(284, 13, 'product', 7, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Very good for 4C detangling', NULL, '2025-12-14 11:50:23', 1, 0, NULL, 0),
(285, 13, 'product', 61, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Fetched from amazon', NULL, '2025-12-14 11:50:23', 1, 0, NULL, 0),
(286, 13, 'product', 62, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Fetched from amazon', NULL, '2025-12-14 11:50:23', 1, 0, NULL, 0),
(287, 13, 'product', 64, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Fetched from amazon', NULL, '2025-12-14 11:50:23', 1, 0, NULL, 0),
(288, 13, 'product', 65, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Fetched from ulta', NULL, '2025-12-14 11:50:23', 1, 0, NULL, 0),
(289, 13, 'product', 1, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Works for 4C, follow with intensive conditioning', NULL, '2025-12-14 11:50:23', 1, 0, NULL, 0),
(290, 13, 'product', 63, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Fetched from ulta', NULL, '2025-12-14 11:50:23', 1, 0, NULL, 0),
(291, 13, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Non-negotiable for 4C hair Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0),
(292, 13, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Very important for 4C growth Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0),
(293, 13, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Very important for 4C growth Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0),
(294, 13, 'method', NULL, 2, NULL, NULL, 'medium', 'Effective method for your hair type. Very important for 4C growth Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0),
(295, 13, 'method', NULL, 2, NULL, NULL, 'medium', 'Effective method for your hair type. Very important for 4C growth Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0),
(296, 13, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Non-negotiable for 4C hair Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0),
(297, 13, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Non-negotiable for 4C hair Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0);
INSERT INTO `user_recommendations` (`recommendation_id`, `profile_id`, `recommendation_type`, `product_id`, `method_id`, `pitfall_id`, `style_id`, `priority`, `personalized_note`, `reason_for_recommendation`, `generated_at`, `is_active`, `user_dismissed`, `age_consideration`, `age_modified`) VALUES
(298, 13, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Non-negotiable for 4C hair Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0),
(299, 13, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Non-negotiable for 4C hair Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0),
(300, 13, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Non-negotiable for 4C hair Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0),
(301, 13, 'pitfall_avoidance', NULL, NULL, 1, NULL, 'critical', 'Important to avoid for your hair type. 4C hair extremely prone to heat damage', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0),
(302, 13, 'pitfall_avoidance', NULL, NULL, 3, NULL, 'critical', 'Important to avoid for your hair type. Extremely high risk, edges very fragile', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0),
(303, 13, 'pitfall_avoidance', NULL, NULL, 6, NULL, 'critical', 'Important to avoid for your hair type. 4C most fragile when wet, avoid brushing', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0),
(304, 13, 'pitfall_avoidance', NULL, NULL, 1, NULL, 'critical', 'Important to avoid for your hair type. 4C hair extremely prone to heat damage', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0),
(305, 13, 'pitfall_avoidance', NULL, NULL, 3, NULL, 'critical', 'Important to avoid for your hair type. Extremely high risk, edges very fragile', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0),
(306, 13, 'pitfall_avoidance', NULL, NULL, 6, NULL, 'critical', 'Important to avoid for your hair type. 4C most fragile when wet, avoid brushing', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0),
(307, 13, 'pitfall_avoidance', NULL, NULL, 1, NULL, 'critical', 'Important to avoid for your hair type. 4C hair extremely prone to heat damage', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0),
(308, 13, 'pitfall_avoidance', NULL, NULL, 3, NULL, 'critical', 'Important to avoid for your hair type. Extremely high risk, edges very fragile', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0),
(309, 13, 'pitfall_avoidance', NULL, NULL, 6, NULL, 'critical', 'Important to avoid for your hair type. 4C most fragile when wet, avoid brushing', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0),
(310, 13, 'pitfall_avoidance', NULL, NULL, 5, NULL, 'high', 'Important to avoid for your hair type. Extremely harsh on 4C hair', NULL, '2025-12-14 11:50:23', 1, 0, '0', 0),
(311, 14, 'product', 1, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Works for 1A but may be heavy - use sparingly', NULL, '2025-12-14 13:36:38', 0, 0, NULL, 0),
(312, 14, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Beneficial for all types including 1A Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 13:36:38', 0, 0, '0', 0),
(313, 14, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Beneficial for all types including 1A Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 13:36:38', 0, 0, '0', 0),
(314, 14, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Beneficial for all types including 1A Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 13:36:38', 0, 0, '0', 0),
(315, 14, 'method', NULL, 2, NULL, NULL, 'medium', 'Effective method for your hair type. Beneficial for all types including 1A Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 13:36:38', 0, 0, '0', 0),
(316, 14, 'method', NULL, 2, NULL, NULL, 'medium', 'Effective method for your hair type. Beneficial for all types including 1A Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 13:36:38', 0, 0, '0', 0),
(317, 14, 'method', NULL, 2, NULL, NULL, 'medium', 'Effective method for your hair type. Beneficial for all types including 1A Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 13:36:38', 0, 0, '0', 0),
(318, 14, 'method', NULL, 2, NULL, NULL, 'low', 'Effective method for your hair type. Beneficial for all types including 1A Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 13:36:38', 0, 0, '0', 0),
(319, 14, 'method', NULL, 2, NULL, NULL, 'low', 'Effective method for your hair type. Beneficial for all types including 1A Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 13:36:38', 0, 0, '0', 0),
(320, 14, 'method', NULL, 2, NULL, NULL, 'low', 'Effective method for your hair type. Beneficial for all types including 1A Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 13:36:38', 0, 0, '0', 0),
(321, 14, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Important for 1A moisture Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 13:36:38', 0, 0, '0', 0),
(322, 14, 'product', 65, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Fetched from ulta', NULL, '2025-12-14 13:36:49', 1, 0, NULL, 0),
(323, 14, 'product', 63, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Fetched from ulta', NULL, '2025-12-14 13:36:49', 1, 0, NULL, 0),
(324, 14, 'product', 1, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Works for 1A but may be heavy - use sparingly', NULL, '2025-12-14 13:36:49', 1, 0, NULL, 0),
(325, 14, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Beneficial for all types including 1A Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 13:36:49', 1, 0, '0', 0),
(326, 14, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Beneficial for all types including 1A Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 13:36:49', 1, 0, '0', 0),
(327, 14, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Beneficial for all types including 1A Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 13:36:49', 1, 0, '0', 0),
(328, 14, 'method', NULL, 2, NULL, NULL, 'medium', 'Effective method for your hair type. Beneficial for all types including 1A Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 13:36:49', 1, 0, '0', 0),
(329, 14, 'method', NULL, 2, NULL, NULL, 'medium', 'Effective method for your hair type. Beneficial for all types including 1A Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 13:36:49', 1, 0, '0', 0),
(330, 14, 'method', NULL, 2, NULL, NULL, 'medium', 'Effective method for your hair type. Beneficial for all types including 1A Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 13:36:49', 1, 0, '0', 0),
(331, 14, 'method', NULL, 2, NULL, NULL, 'low', 'Effective method for your hair type. Beneficial for all types including 1A Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 13:36:49', 1, 0, '0', 0),
(332, 14, 'method', NULL, 2, NULL, NULL, 'low', 'Effective method for your hair type. Beneficial for all types including 1A Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 13:36:49', 1, 0, '0', 0),
(333, 14, 'method', NULL, 2, NULL, NULL, 'low', 'Effective method for your hair type. Beneficial for all types including 1A Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 13:36:49', 1, 0, '0', 0),
(334, 14, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Important for 1A moisture Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 13:36:49', 1, 0, '0', 0),
(335, 15, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Best for 4C, heavy moisture and growth promotion', NULL, '2025-12-14 16:42:52', 1, 0, NULL, 0),
(336, 15, 'product', 3, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Best for 4C hair', NULL, '2025-12-14 16:42:52', 1, 0, NULL, 0),
(337, 15, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Best for 4C', NULL, '2025-12-14 16:42:52', 1, 0, NULL, 0),
(338, 15, 'product', 7, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Very good for 4C detangling', NULL, '2025-12-14 16:42:52', 1, 0, NULL, 0),
(339, 15, 'product', 61, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Fetched from amazon', NULL, '2025-12-14 16:42:52', 1, 0, NULL, 0),
(340, 15, 'product', 62, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Fetched from amazon', NULL, '2025-12-14 16:42:52', 1, 0, NULL, 0),
(341, 15, 'product', 64, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Fetched from amazon', NULL, '2025-12-14 16:42:52', 1, 0, NULL, 0),
(342, 15, 'product', 65, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Fetched from ulta', NULL, '2025-12-14 16:42:52', 1, 0, NULL, 0),
(343, 15, 'product', 1, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Works for 4C, follow with intensive conditioning', NULL, '2025-12-14 16:42:52', 1, 0, NULL, 0),
(344, 15, 'product', 63, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Fetched from ulta', NULL, '2025-12-14 16:42:52', 1, 0, NULL, 0),
(345, 15, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Non-negotiable for 4C hair Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(346, 15, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Very important for 4C growth Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(347, 15, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Very important for 4C growth Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(348, 15, 'method', NULL, 2, NULL, NULL, 'medium', 'Effective method for your hair type. Very important for 4C growth Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(349, 15, 'method', NULL, 2, NULL, NULL, 'medium', 'Effective method for your hair type. Very important for 4C growth Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(350, 15, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Non-negotiable for 4C hair Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(351, 15, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Non-negotiable for 4C hair Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(352, 15, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Non-negotiable for 4C hair Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(353, 15, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Non-negotiable for 4C hair Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(354, 15, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Non-negotiable for 4C hair Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(355, 15, 'pitfall_avoidance', NULL, NULL, 1, NULL, 'critical', 'Important to avoid for your hair type. 4C hair extremely prone to heat damage', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(356, 15, 'pitfall_avoidance', NULL, NULL, 3, NULL, 'critical', 'Important to avoid for your hair type. Extremely high risk, edges very fragile', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(357, 15, 'pitfall_avoidance', NULL, NULL, 6, NULL, 'critical', 'Important to avoid for your hair type. 4C most fragile when wet, avoid brushing', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(358, 15, 'pitfall_avoidance', NULL, NULL, 1, NULL, 'critical', 'Important to avoid for your hair type. 4C hair extremely prone to heat damage', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(359, 15, 'pitfall_avoidance', NULL, NULL, 3, NULL, 'critical', 'Important to avoid for your hair type. Extremely high risk, edges very fragile', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(360, 15, 'pitfall_avoidance', NULL, NULL, 6, NULL, 'critical', 'Important to avoid for your hair type. 4C most fragile when wet, avoid brushing', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(361, 15, 'pitfall_avoidance', NULL, NULL, 1, NULL, 'critical', 'Important to avoid for your hair type. 4C hair extremely prone to heat damage', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(362, 15, 'pitfall_avoidance', NULL, NULL, 3, NULL, 'critical', 'Important to avoid for your hair type. Extremely high risk, edges very fragile', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(363, 15, 'pitfall_avoidance', NULL, NULL, 6, NULL, 'critical', 'Important to avoid for your hair type. 4C most fragile when wet, avoid brushing', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(364, 15, 'pitfall_avoidance', NULL, NULL, 5, NULL, 'high', 'Important to avoid for your hair type. Extremely harsh on 4C hair', NULL, '2025-12-14 16:42:52', 1, 0, '0', 0),
(365, 16, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Best for 4C, heavy moisture and growth promotion', NULL, '2025-12-14 21:00:24', 1, 0, NULL, 0),
(366, 16, 'product', 3, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Best for 4C hair', NULL, '2025-12-14 21:00:24', 1, 0, NULL, 0),
(367, 16, 'product', 4, NULL, NULL, NULL, 'high', 'Recommended for your hair type. Best for 4C', NULL, '2025-12-14 21:00:24', 1, 0, NULL, 0),
(368, 16, 'product', 7, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Very good for 4C detangling', NULL, '2025-12-14 21:00:24', 1, 0, NULL, 0),
(369, 16, 'product', 61, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Fetched from amazon', NULL, '2025-12-14 21:00:24', 1, 0, NULL, 0),
(370, 16, 'product', 62, NULL, NULL, NULL, 'medium', 'Recommended for your hair type. Fetched from amazon', NULL, '2025-12-14 21:00:24', 1, 0, NULL, 0),
(371, 16, 'product', 64, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Fetched from amazon', NULL, '2025-12-14 21:00:24', 1, 0, NULL, 0),
(372, 16, 'product', 65, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Fetched from ulta', NULL, '2025-12-14 21:00:24', 1, 0, NULL, 0),
(373, 16, 'product', 1, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Works for 4C, follow with intensive conditioning', NULL, '2025-12-14 21:00:24', 1, 0, NULL, 0),
(374, 16, 'product', 63, NULL, NULL, NULL, 'low', 'Recommended for your hair type. Fetched from ulta', NULL, '2025-12-14 21:00:24', 1, 0, NULL, 0),
(375, 16, 'method', NULL, 3, NULL, NULL, 'high', 'Effective method for your hair type. Non-negotiable for 4C hair Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0),
(376, 16, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Very important for 4C growth Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0),
(377, 16, 'method', NULL, 2, NULL, NULL, 'high', 'Effective method for your hair type. Very important for 4C growth Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0),
(378, 16, 'method', NULL, 2, NULL, NULL, 'medium', 'Effective method for your hair type. Very important for 4C growth Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0),
(379, 16, 'method', NULL, 2, NULL, NULL, 'medium', 'Effective method for your hair type. Very important for 4C growth Age-specific: Excellent option for retention Precautions: Ensure proper installation', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0),
(380, 16, 'method', NULL, 3, NULL, NULL, 'medium', 'Effective method for your hair type. Non-negotiable for 4C hair Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0),
(381, 16, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Non-negotiable for 4C hair Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0),
(382, 16, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Non-negotiable for 4C hair Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0),
(383, 16, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Non-negotiable for 4C hair Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0),
(384, 16, 'method', NULL, 3, NULL, NULL, 'low', 'Effective method for your hair type. Non-negotiable for 4C hair Age-specific: Essential for maintaining health Precautions: Balance protein and moisture', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0),
(385, 16, 'pitfall_avoidance', NULL, NULL, 1, NULL, 'critical', 'Important to avoid for your hair type. 4C hair extremely prone to heat damage', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0),
(386, 16, 'pitfall_avoidance', NULL, NULL, 3, NULL, 'critical', 'Important to avoid for your hair type. Extremely high risk, edges very fragile', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0),
(387, 16, 'pitfall_avoidance', NULL, NULL, 6, NULL, 'critical', 'Important to avoid for your hair type. 4C most fragile when wet, avoid brushing', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0),
(388, 16, 'pitfall_avoidance', NULL, NULL, 1, NULL, 'critical', 'Important to avoid for your hair type. 4C hair extremely prone to heat damage', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0),
(389, 16, 'pitfall_avoidance', NULL, NULL, 3, NULL, 'critical', 'Important to avoid for your hair type. Extremely high risk, edges very fragile', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0),
(390, 16, 'pitfall_avoidance', NULL, NULL, 6, NULL, 'critical', 'Important to avoid for your hair type. 4C most fragile when wet, avoid brushing', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0),
(391, 16, 'pitfall_avoidance', NULL, NULL, 1, NULL, 'critical', 'Important to avoid for your hair type. 4C hair extremely prone to heat damage', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0),
(392, 16, 'pitfall_avoidance', NULL, NULL, 3, NULL, 'critical', 'Important to avoid for your hair type. Extremely high risk, edges very fragile', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0),
(393, 16, 'pitfall_avoidance', NULL, NULL, 6, NULL, 'critical', 'Important to avoid for your hair type. 4C most fragile when wet, avoid brushing', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0),
(394, 16, 'pitfall_avoidance', NULL, NULL, 5, NULL, 'high', 'Important to avoid for your hair type. Extremely harsh on 4C hair', NULL, '2025-12-14 21:00:24', 1, 0, '0', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `age_hair_factors`
--
ALTER TABLE `age_hair_factors`
  ADD PRIMARY KEY (`factor_id`),
  ADD KEY `idx_age_group` (`age_group`);

--
-- Indexes for table `age_specific_concerns`
--
ALTER TABLE `age_specific_concerns`
  ADD PRIMARY KEY (`age_concern_id`),
  ADD KEY `idx_age_concern` (`age_group`);

--
-- Indexes for table `content_age_appropriateness`
--
ALTER TABLE `content_age_appropriateness`
  ADD PRIMARY KEY (`content_age_id`),
  ADD KEY `idx_content_age` (`content_id`,`age_group`);

--
-- Indexes for table `content_hair_type_relevance`
--
ALTER TABLE `content_hair_type_relevance`
  ADD PRIMARY KEY (`relevance_id`),
  ADD KEY `content_id` (`content_id`),
  ADD KEY `hair_type_id` (`hair_type_id`);

--
-- Indexes for table `diagnosis_causes`
--
ALTER TABLE `diagnosis_causes`
  ADD PRIMARY KEY (`cause_id`),
  ADD KEY `idx_cause_category` (`category`);

--
-- Indexes for table `educational_content`
--
ALTER TABLE `educational_content`
  ADD PRIMARY KEY (`content_id`),
  ADD KEY `idx_content_type` (`content_type`),
  ADD KEY `idx_content_offline` (`is_offline_available`);

--
-- Indexes for table `growth_forecasts`
--
ALTER TABLE `growth_forecasts`
  ADD PRIMARY KEY (`forecast_id`),
  ADD KEY `idx_forecast_profile` (`profile_id`),
  ADD KEY `idx_forecast_date` (`forecast_date`);

--
-- Indexes for table `hair_types`
--
ALTER TABLE `hair_types`
  ADD PRIMARY KEY (`hair_type_id`),
  ADD UNIQUE KEY `type_code` (`type_code`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `idx_product_category` (`category`),
  ADD KEY `idx_product_rating` (`rating`);

--
-- Indexes for table `product_age_appropriateness`
--
ALTER TABLE `product_age_appropriateness`
  ADD PRIMARY KEY (`appropriateness_id`),
  ADD KEY `idx_product_age` (`product_id`,`age_group`);

--
-- Indexes for table `product_hair_type_compatibility`
--
ALTER TABLE `product_hair_type_compatibility`
  ADD PRIMARY KEY (`compatibility_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `hair_type_id` (`hair_type_id`);

--
-- Indexes for table `protective_styles`
--
ALTER TABLE `protective_styles`
  ADD PRIMARY KEY (`style_id`),
  ADD KEY `idx_style_category` (`category`),
  ADD KEY `idx_style_difficulty` (`difficulty_level`);

--
-- Indexes for table `routine_completion_log`
--
ALTER TABLE `routine_completion_log`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `idx_log_routine` (`routine_id`),
  ADD KEY `idx_log_profile_date` (`profile_id`,`completion_date`);

--
-- Indexes for table `routine_steps`
--
ALTER TABLE `routine_steps`
  ADD PRIMARY KEY (`step_id`),
  ADD KEY `routine_id` (`routine_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `method_id` (`method_id`);

--
-- Indexes for table `style_hair_type_compatibility`
--
ALTER TABLE `style_hair_type_compatibility`
  ADD PRIMARY KEY (`compatibility_id`),
  ADD KEY `style_id` (`style_id`),
  ADD KEY `hair_type_id` (`hair_type_id`);

--
-- Indexes for table `symptom_cause_mapping`
--
ALTER TABLE `symptom_cause_mapping`
  ADD PRIMARY KEY (`mapping_id`),
  ADD KEY `symptom_id` (`symptom_id`),
  ADD KEY `cause_id` (`cause_id`);

--
-- Indexes for table `treatment_solutions`
--
ALTER TABLE `treatment_solutions`
  ADD PRIMARY KEY (`solution_id`),
  ADD KEY `cause_id` (`cause_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `method_id` (`method_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_user_email` (`email`),
  ADD KEY `idx_user_active` (`is_active`),
  ADD KEY `idx_parent_user` (`parent_user_id`),
  ADD KEY `idx_child_account` (`is_child_account`);

--
-- Indexes for table `user_diagnoses`
--
ALTER TABLE `user_diagnoses`
  ADD PRIMARY KEY (`diagnosis_id`),
  ADD KEY `idx_diagnosis_profile` (`profile_id`),
  ADD KEY `idx_diagnosis_date` (`diagnosis_date`);

--
-- Indexes for table `user_hair_concerns`
--
ALTER TABLE `user_hair_concerns`
  ADD PRIMARY KEY (`user_concern_id`),
  ADD KEY `profile_id` (`profile_id`),
  ADD KEY `concern_id` (`concern_id`);

--
-- Indexes for table `user_hair_profiles`
--
ALTER TABLE `user_hair_profiles`
  ADD PRIMARY KEY (`profile_id`),
  ADD KEY `idx_profile_user` (`user_id`),
  ADD KEY `idx_profile_hair_type` (`hair_type_id`);

--
-- Indexes for table `user_notifications`
--
ALTER TABLE `user_notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `idx_notification_user` (`user_id`),
  ADD KEY `idx_notification_read` (`is_read`);

--
-- Indexes for table `user_recommendations`
--
ALTER TABLE `user_recommendations`
  ADD PRIMARY KEY (`recommendation_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `method_id` (`method_id`),
  ADD KEY `pitfall_id` (`pitfall_id`),
  ADD KEY `style_id` (`style_id`),
  ADD KEY `idx_recommendations_profile` (`profile_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `age_hair_factors`
--
ALTER TABLE `age_hair_factors`
  MODIFY `factor_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `age_specific_concerns`
--
ALTER TABLE `age_specific_concerns`
  MODIFY `age_concern_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `content_age_appropriateness`
--
ALTER TABLE `content_age_appropriateness`
  MODIFY `content_age_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `content_hair_type_relevance`
--
ALTER TABLE `content_hair_type_relevance`
  MODIFY `relevance_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `diagnosis_causes`
--
ALTER TABLE `diagnosis_causes`
  MODIFY `cause_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `educational_content`
--
ALTER TABLE `educational_content`
  MODIFY `content_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `growth_forecasts`
--
ALTER TABLE `growth_forecasts`
  MODIFY `forecast_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hair_types`
--
ALTER TABLE `hair_types`
  MODIFY `hair_type_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT for table `product_age_appropriateness`
--
ALTER TABLE `product_age_appropriateness`
  MODIFY `appropriateness_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_hair_type_compatibility`
--
ALTER TABLE `product_hair_type_compatibility`
  MODIFY `compatibility_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `protective_styles`
--
ALTER TABLE `protective_styles`
  MODIFY `style_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `routine_completion_log`
--
ALTER TABLE `routine_completion_log`
  MODIFY `log_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `routine_steps`
--
ALTER TABLE `routine_steps`
  MODIFY `step_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=181;

--
-- AUTO_INCREMENT for table `style_hair_type_compatibility`
--
ALTER TABLE `style_hair_type_compatibility`
  MODIFY `compatibility_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `symptom_cause_mapping`
--
ALTER TABLE `symptom_cause_mapping`
  MODIFY `mapping_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `treatment_solutions`
--
ALTER TABLE `treatment_solutions`
  MODIFY `solution_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `user_diagnoses`
--
ALTER TABLE `user_diagnoses`
  MODIFY `diagnosis_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `user_hair_concerns`
--
ALTER TABLE `user_hair_concerns`
  MODIFY `user_concern_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=369;

--
-- AUTO_INCREMENT for table `user_hair_profiles`
--
ALTER TABLE `user_hair_profiles`
  MODIFY `profile_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `user_notifications`
--
ALTER TABLE `user_notifications`
  MODIFY `notification_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_recommendations`
--
ALTER TABLE `user_recommendations`
  MODIFY `recommendation_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=395;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `content_age_appropriateness`
--
ALTER TABLE `content_age_appropriateness`
  ADD CONSTRAINT `content_age_appropriateness_ibfk_1` FOREIGN KEY (`content_id`) REFERENCES `educational_content` (`content_id`) ON DELETE CASCADE;

--
-- Constraints for table `content_hair_type_relevance`
--
ALTER TABLE `content_hair_type_relevance`
  ADD CONSTRAINT `content_hair_type_relevance_ibfk_1` FOREIGN KEY (`content_id`) REFERENCES `educational_content` (`content_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `content_hair_type_relevance_ibfk_2` FOREIGN KEY (`hair_type_id`) REFERENCES `hair_types` (`hair_type_id`) ON DELETE CASCADE;

--
-- Constraints for table `growth_forecasts`
--
ALTER TABLE `growth_forecasts`
  ADD CONSTRAINT `growth_forecasts_ibfk_1` FOREIGN KEY (`profile_id`) REFERENCES `user_hair_profiles` (`profile_id`) ON DELETE CASCADE;

--
-- Constraints for table `product_age_appropriateness`
--
ALTER TABLE `product_age_appropriateness`
  ADD CONSTRAINT `product_age_appropriateness_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `product_hair_type_compatibility`
--
ALTER TABLE `product_hair_type_compatibility`
  ADD CONSTRAINT `product_hair_type_compatibility_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_hair_type_compatibility_ibfk_2` FOREIGN KEY (`hair_type_id`) REFERENCES `hair_types` (`hair_type_id`) ON DELETE CASCADE;

--
-- Constraints for table `routine_completion_log`
--
ALTER TABLE `routine_completion_log`
  ADD CONSTRAINT `routine_completion_log_ibfk_2` FOREIGN KEY (`profile_id`) REFERENCES `user_hair_profiles` (`profile_id`) ON DELETE CASCADE;

--
-- Constraints for table `routine_steps`
--
ALTER TABLE `routine_steps`
  ADD CONSTRAINT `routine_steps_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE SET NULL;

--
-- Constraints for table `style_hair_type_compatibility`
--
ALTER TABLE `style_hair_type_compatibility`
  ADD CONSTRAINT `style_hair_type_compatibility_ibfk_1` FOREIGN KEY (`style_id`) REFERENCES `protective_styles` (`style_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `style_hair_type_compatibility_ibfk_2` FOREIGN KEY (`hair_type_id`) REFERENCES `hair_types` (`hair_type_id`) ON DELETE CASCADE;

--
-- Constraints for table `treatment_solutions`
--
ALTER TABLE `treatment_solutions`
  ADD CONSTRAINT `treatment_solutions_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE SET NULL;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_user_parent` FOREIGN KEY (`parent_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `user_diagnoses`
--
ALTER TABLE `user_diagnoses`
  ADD CONSTRAINT `user_diagnoses_ibfk_1` FOREIGN KEY (`profile_id`) REFERENCES `user_hair_profiles` (`profile_id`) ON DELETE CASCADE;

--
-- Constraints for table `user_hair_concerns`
--
ALTER TABLE `user_hair_concerns`
  ADD CONSTRAINT `user_hair_concerns_ibfk_1` FOREIGN KEY (`profile_id`) REFERENCES `user_hair_profiles` (`profile_id`) ON DELETE CASCADE;

--
-- Constraints for table `user_hair_profiles`
--
ALTER TABLE `user_hair_profiles`
  ADD CONSTRAINT `user_hair_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `user_notifications`
--
ALTER TABLE `user_notifications`
  ADD CONSTRAINT `user_notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `user_recommendations`
--
ALTER TABLE `user_recommendations`
  ADD CONSTRAINT `user_recommendations_ibfk_1` FOREIGN KEY (`profile_id`) REFERENCES `user_hair_profiles` (`profile_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_recommendations_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_recommendations_ibfk_5` FOREIGN KEY (`style_id`) REFERENCES `protective_styles` (`style_id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
