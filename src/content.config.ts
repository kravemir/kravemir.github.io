import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const howTo = defineCollection({
	loader: glob({ base: './content/how-to', pattern: '**/*.{md,mdx}' }),
	schema: ({ image }) =>
		z.object({
			title: z.string(),
			description: z.string().optional(),
			intro: z.string().optional(),
      images: z.record(
        z.string(),
        z.object({
          image: image()
        })
      ).optional(),
      coverImage: z.string().optional()
		}),
});

export const collections = { howTo };
