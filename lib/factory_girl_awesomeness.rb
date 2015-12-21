require 'factory_girl'

module FactoryGirl

  unless sequences.registered?(:attributor_context)
    sequence = Sequence.new(:attributor_context) { |n| SecureRandom.hex }
    register_sequence(sequence)
  end

  class DefinitionProxy
    def traits_for!(media_type)

      transient do
        attributor_context
      end

      media_type.attributes.each do |name, attribute|
        if attribute.type < Praxis::Blueprint
          next
        elsif attribute.type < Attributor::Collection && attribute.type.member_attribute.type < Praxis::Blueprint
          next
        end

        example = Proc.new do
          ctx = [attributor_context, name]
          val = attribute.example(ctx, parent: self)
          attribute.dump(val, context: ctx )
        end

        block = Proc.new do
          send(name, &example)
        end

        @definition.define_trait(Trait.new(name, &block))
      end
    end
  end


  # Tweak the build order to try traits first, otherwise
  # sequences will trump our traits.
  class Declaration::Implicit
    def build_with_media_type
      if @factory.defined_traits.find { |t| t.name == name }
        @factory.inherit_traits([name])
        return []
      else
        build_without_media_type
      end
    end
    alias_method_chain :build, :media_type
  end

end
